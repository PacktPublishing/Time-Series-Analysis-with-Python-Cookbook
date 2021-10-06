from influxdb_client import InfluxDBClient, WriteOptions
from influxdb_client.client.write_api import SYNCHRONOUS
import pandas as pd
from  pathlib import Path

path = Path('../../datasets/Ch5/ExtraSensory/')
file = '0A986513-7828-4D53-AA1F-E02D6DF9561B.features_labels.csv.gz'

columns = ['timestamp',
           'watch_acceleration:magnitude_stats:mean']

df = pd.read_csv(path.joinpath(file),
                usecols=columns)

df = df.fillna(method='backfill')

df.columns = ['timestamp','acc']

df.shape



df['timestamp'] = pd.to_datetime(df['timestamp'],
                                  origin='unix',
                                  unit='s',
                                  utc=True)



df.set_index('timestamp', inplace=True)

bucket = "stocks_ts"
org = "my-org"
token = "c5c0JUoz-joisPCttI6hy8aLccEyaflyfNj1S_Kff34N_4moiCQacH8BLbLzFu4qWTP8ibSk3JNYtv9zlUwxeA=="
client = InfluxDBClient(url="http://localhost:8086", token=token)


writer = client.write_api(WriteOptions(SYNCHRONOUS,
                     batch_size=500,
                     max_retries=5_000))


writer.write(bucket=bucket,
                org=org,
                record=df,
                write_precision='ns',
                data_frame_measurement_name='acc',
                data_frame_tag_columns=[])

query = '''
         from(bucket: "stocks_ts")
         |> range(start: 2015-12-08)
         '''

result = client.query_api()

influx_df = result.query_data_frame(
                             org=org,
                             query=query,
                             data_frame_index='_time')

influx_df.columns

