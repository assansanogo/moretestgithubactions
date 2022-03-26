import os
import glob2
import base64
import pdfkit

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (Mail, Attachment, FileContent, FileName, FileType, Disposition)


message = Mail(
    from_email=os.environ.get('SENDER_EMAIL'),
    to_emails=os.environ.get('DEST_EMAIL'),
    subject='Sending clean data from Streamline datascience',
    html_content='<strong>But it was sent from Python</strong>'
)

config = pdfkit.configuration(wkhtmltopdf='/usr/bin/wkhtmltopdf')
report_csv = glob2.glob(os.path.join(os.getcwd(), "*.csv"))
pdfkit.from_file(report_csv, './report.pdf', configuration=config)

with open('./report.pdf', 'rb') as f:
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
print(os.environ.get('SENDGRID_API_KEY'))
sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
response = sg.send(message)
print(response.status_code, response.body, response.headers)
