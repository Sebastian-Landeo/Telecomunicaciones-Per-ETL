import pandas as pd
import pymysql
from decouple import config

# Conexión a la base de datos
user = config('DB_USER')
password = config('DB_PASSWORD')
host = config('DB_HOST')
database = config('DB_NAME')
port = int(config('DB_PORT'))

conn = pymysql.connect(
    host=host, user=user, password=password, database=database, port=port
)
cursor = conn.cursor()

# Importar archivo .csv
df = pd.read_csv("Telecomunicaciones_Transformado.csv")

# Insertar valores únicos en dim_departamento
valores_unicos_departamento = df[['departamento']].drop_duplicates()
sql_departamento = "INSERT INTO dim_departamento (departamento) VALUES (%s)"
for _, row in valores_unicos_departamento.iterrows():
    cursor.execute("SELECT COUNT(*) FROM dim_departamento WHERE departamento = %s", (row['departamento'],))
    if cursor.fetchone()[0] == 0:
        cursor.execute(sql_departamento, (row['departamento'],))

# Función para insertar valores en otras tablas
def insertar_datos(tabla, columnas):
    valores = df[list(columnas)]
    placeholders = ', '.join(['%s'] * len(columnas))
    sql = f"INSERT INTO {tabla} ({', '.join(columnas)}) VALUES ({placeholders})"
    
    for _, row in valores.iterrows():
        cursor.execute(sql, tuple(row))

# Insertar en cada tabla de dimensión (excepto dim_departamento)
insertar_datos('dim_telefono', ['tel_fija_unid', 'tel_movil_unid', 'tel_pub_unid'])
insertar_datos('dim_hogar', ['hogar_1_radio_porc', 'hogar_1_tv_porc', 'hogar_con_cable_porc', 'hogar_1_compu_porc'])
insertar_datos('dim_pbi', ['pbi_regional_miles', 'id_logit'])
insertar_datos('dim_internet', ['uso_inter_porc', 'sub_inter_fijo_unid'])
insertar_datos('dim_computadora', ['vab_tel_miles_2007', 'compus', 'uso_cabina_porc'])

# Insertar datos en telecomunicaciones_stg
columnas_stg = ['departamento', 'anio', 'uso_cabina_porc', 'tel_fija_unid', 'tel_movil_unid', 'tel_pub_unid',
                'uso_inter_porc', 'sub_inter_fijo_unid', 'vab_tel_miles_2007', 'pbi_regional_miles',
                'hogar_1_radio_porc', 'hogar_1_tv_porc', 'hogar_con_cable_porc', 'hogar_1_compu_porc', 'compus', 'id_logit']

insertar_datos('telecomunicaciones_stg', columnas_stg)

# Insertar datos en la tabla de hechos fac_telecomunicaciones
sql_fac = """
INSERT INTO fac_telecomunicaciones (id_departamento, id_telefono, id_hogar, id_pbi, id_internet, id_computadora, anio)
SELECT d.id_departamento, t.id_telefono, h.id_hogar, p.id_pbi, i.id_internet, c.id_computadora, s.anio
FROM telecomunicaciones_stg s
JOIN dim_departamento d ON d.departamento = s.departamento
JOIN dim_telefono t ON t.id_telefono = s.id
JOIN dim_hogar h ON h.id_hogar = s.id
JOIN dim_pbi p ON p.id_pbi = s.id
JOIN dim_internet i ON i.id_internet = s.id
JOIN dim_computadora c ON c.id_computadora = s.id
"""
cursor.execute(sql_fac)

# Confirmar cambios y cerrar conexión
conn.commit()
cursor.close()
conn.close()

print("Datos insertados correctamente en las tablas de dimensión, en telecomunicaciones_stg y en fac_telecomunicaciones.")
