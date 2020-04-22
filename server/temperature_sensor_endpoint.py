import boto3
import traceback

from uuid import uuid4
from datetime import datetime


def log_to_s3(key, body):
    boto3.client('s3').put_object(
        ACL='private',
        Body=body,
        Bucket='robota.sensors',
        Key=f'temperature_sensor/v1/{key}',
    )


def log_entry(event, timestamp, uuid):
    sensor_id, temperature, humidity = event.split(';')

    boto3.client('cloudwatch').put_metric_data(
        Namespace='temperature_sensor',
        MetricData=[
            {
                'MetricName': 'temperature',
                'Timestamp': timestamp,
                'Value': float(temperature),
                'Unit': 'Count',
                'Dimensions': [
                    {
                        'Name': 'sensor_id',
                        'Value': sensor_id,
                    },
                ],
            },
            {
                'MetricName': 'humidity',
                'Timestamp': timestamp,
                'Value': float(humidity),
                'Unit': 'Percent',
                'Dimensions': [
                    {
                        'Name': 'sensor_id',
                        'Value': sensor_id,
                    },
                ],
            },
        ]
    )

    log_to_s3(
        key=f'raw/{uuid}',
        body=f'{int(timestamp.timestamp())} : {event}'
    )


def log_error(error, event, timestamp, uuid):
    boto3.client('cloudwatch').put_metric_data(
        Namespace='temperature_sensor',
        MetricData=[
            {
                'MetricName': 'error_count',
                'Timestamp': timestamp,
                'Value': 1,
                'Unit': 'Count',
            },
        ]
    )

    t_back = traceback.format_exc()
    log_to_s3(
        key=f'error/{uuid}',
        body=f'{timestamp} : {event} : {error} : {t_back}'
    )


def lambda_handler(event, _):
    timestamp = datetime.now()
    uuid = uuid4()

    try:
        log_entry(
            event=event,
            timestamp=timestamp,
            uuid=uuid
        )
        return 'All good'

    except Exception as e:
        log_error(
            error=e,
            event=event,
            timestamp=timestamp,
            uuid=uuid
        )
        return 'Something went wrong'
