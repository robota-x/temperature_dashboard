import boto3
import time
import uuid
import sys
from datetime import datetime


def log_to_cloudwatch(name, value, unit=None):
    boto3.client('cloudwatch').put_metric_data(
        Namespace='temperature_sensor',
        MetricData=[
            {
                'MetricName': name,
                'Timestamp': datetime.now(),
                'Value': value,
                'Unit': unit,
            },
        ]
    )


def log_to_s3(key, body):
    boto3.client('s3').put_object(
        ACL='private',
        Body=body,
        Bucket='robota.sensors',
        Key=f'temperature_sensor/v1/{key}',
    )


def log_error(e, event):
    log_to_cloudwatch(
        name='errorCount',
        value=1,
        unit='Count',
    )
    log_to_s3(
        key=f'error/{uuid.uuid4()}',
        body=str(e),
    )


def log_entry(event):
    f'{int(time.time())};{event}'


def lambda_handler(event, _):
    try:
        log_to_s3(f'raw/{uuid.uuid4()}', event)
        # log_to_cloudwatch(event)
        return 'All good'

    except Exception as e:
        log_error(e, event)
        return 'Something went wrong'
