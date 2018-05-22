import boto3
import time
import uuid
from datetime import datetime


def log_to_s3(key, body):
    boto3.client('s3').put_object(
        ACL='private',
        Body=body,
        Bucket='robota.sensors',
        Key=f'temperature_sensor/v1/{key}',
    )


def log_entry(event):
    sensor_id, temperature, humidity = event.split(';')

    boto3.client('cloudwatch').put_metric_data(
        Namespace='temperature_sensor',
        MetricData=[
            {
                'MetricName': 'temperature',
                'Timestamp': datetime.now(),
                'Value': float(temperature),
                'Unit': 'Count',
                'Dimensions': [
                    {
                        'Name': 'sensor_id',
                        'Value': sensor_id
                    }
                ],
            },
            {
                'MetricName': 'temperature',
                'Timestamp': datetime.now(),
                'Value': float(humidity),
                'Unit': 'Percent',
                'Dimensions': [
                    {
                        'Name': 'sensor_id',
                        'Value': sensor_id
                    }
                ],
            },
        ]
    )
    log_to_s3(
        key=f'raw/{uuid.uuid4()}',
        body=f'{int(time.time())};{event}'
    )


def log_error(e, event):
    boto3.client('cloudwatch').put_metric_data(
        Namespace='temperature_sensor',
        MetricData=[
            {
                'MetricName': 'error_count',
                'Timestamp': datetime.now(),
                'Value': 1,
                'Unit': 'Count',
            }
        ]
    )

    log_to_s3(
        key=f'error/{uuid.uuid4()}',
        body=str(e),
    )


def lambda_handler(event, _):
    try:
        log_entry(event)
        return 'All good'

    except Exception as e:
        log_error(e, event)
        return 'Something went wrong'
