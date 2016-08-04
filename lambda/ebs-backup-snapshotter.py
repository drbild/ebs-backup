import boto3

from datetime import date

ec2 = boto3.resource('ec2')

def add_years(d, years):
    """How is this not in the standard library!!??"""
    return date(d.year + years, d.month, d.day)

def get_volume_name(volume):
    """Returns the name of this volume or "" if unamed."""
    for tag in volume.tags:
        if tag['Key'] == 'Name':
            return tag['Value']
    return ""

def set_snapshot_name(snapshot, name):
    """Sets the Name tag of the snapshot."""
    snapshot.create_tags(Tags=[{'Key': 'Name', 'Value': name}])

def set_snapshot_delete_on(snapshot, date):
    """Sets the DeleteOn tag of the snapshot."""
    snapshot.create_tags(Tags=[{'Key': 'DeleteOn', 'Value': date}])

def lambda_handler(event, context):
    today       = date.today()
    today_label = today.strftime('%Y-%m-%d')

    if today.day == 1:
        delete_on = add_years(today, 1) # Hold one/month for a year
    else:
        delete_on = today + timedelta(days=31) # Hold daily for a month
    delete_on_label = delete_on.strftime('%Y-%m-%d')

    filters = [{'Name': 'tag-key', 'Values': ['backup', 'Backup']}]
    volumes = ec2.volumes.filter(Filters=filters)

    for volume in volumes:
        volume_id   = volume.volume_id
        volume_name = get_volume_name(volume)
        snapshot_name = "%s-%s" % (volume_name, today_label)
        snapshot_description = "Automated Backup"
        
        print "Creating snapshot of EBS volume %s (%s)..." % (volume_id, volume_name)
        snapshot = volume.create_snapshot(Description=snapshot_description)

        set_snapshot_name(snapshot, snapshot_name)
        set_snapshot_delete_on(snapshot, delete_on_label)

        print "Created snapshot %s." % (snapshot_name)
