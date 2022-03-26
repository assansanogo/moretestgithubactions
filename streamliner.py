import os
import base64

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (Mail, Attachment, FileContent, FileName, FileType, Disposition)


message = Mail(
    from_email=os.environ.get('SENDER_EMAIL'),
    to_emails=os.environ.get('DEST_EMAIL'),
    subject='Sending clean data from Streamline datascience',
    html_content='<strong>But it was sent from Python</strong>'
)

with open('report.pdf', 'rb') as f:
    data = f.read()
    f.close()
encoded_file = base64.b64encode(data).decode()

attachedFile = Attachment(
    FileContent(encoded_file),
    FileName('report.pdf'),
    FileType('application/pdf'),
    Disposition('attachment')
)
message.attachment = attachedFile

sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
response = sg.send(message)
print(response.status_code, response.body, response.headers)
