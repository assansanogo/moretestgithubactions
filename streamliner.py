import os
import glob2
import base64
import pdfkit
import sys

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (Mail, Attachment, FileContent, FileName, FileType, Disposition)

if __name__=='__main__':
    

    
    config = pdfkit.configuration(wkhtmltopdf='/usr/bin/wkhtmltopdf')
    report_csv = glob2.glob(os.path.join(os.getcwd(), "*.csv"))
    pdfkit.from_file(report_csv, './report.pdf', configuration=config)

    with open('./report.pdf', 'rb') as f:
        data = f.read()
        f.close()
    encoded_file = base64.b64encode(data).decode()
 
    
    data = {
    "personalizations": [
        {
        "to": [
            {
            "email": sys.argv[3]
            }
        ],
        "subject": "Sending with SendGrid is Fun"
        }
    ],
    "from": {
        "email": sys.argv[2]
    },
    "content": [
        {
            "type": "text/plain",
            "value": "and easy to do anywhere, even with Python"
        }
    ],
    "attachments": [
    {
        "content": f"{encoded_file}",
        "content_id": "ii_139db99fdb5c3704",
        "disposition": "inline",
        "filename": "file1.jpg",
        "name": "report",
        "type": "pdf"
        }
        ]
    }
    sg = sendgrid.SendGridAPIClient(sys.argv[1])
    response = sg.client.mail.send.post(request_body=data)
    print(response.status_code)
    print(response.body)
    print(response.headers)

