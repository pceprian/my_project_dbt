from prefect import flow
from prefect_dbt.cloud import DbtCloudJob

@flow
def lanzar_primer_job():
    job = DbtCloudJob.load("staging-job")
    print("Iniciando la llamada remota al Trabajo Analítico 1...")
    job.trigger()

@flow
def lanzar_segundo_job():
    job = DbtCloudJob.load("intermediate-and-marts-job")
    print("Iniciando la llamada remota al Trabajo Analítico 2...")
    job.trigger()

@flow
def lanzar_tercer_job():
    job = DbtCloudJob.load("legacy-job")
    print("Iniciando la llamada remota al Trabajo Analítico 3...")
    job.trigger()