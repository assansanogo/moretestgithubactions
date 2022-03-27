import os
import glob2
import base64
import pdfkit
import sys

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (Mail, Attachment, FileContent, FileName, FileType, Disposition)

if __name__=='__main__':
    
    print(sys.argv[0])
    
    config = pdfkit.configuration(wkhtmltopdf='/usr/bin/wkhtmltopdf')
    report_csv = glob2.glob(os.path.join(os.getcwd(), "*.csv"))
    #pdfkit.from_file(report_csv, './report.pdf', configuration=config)



    message = Mail(
        from_email=sys.argv[2],
        to_emails=sys.argv[2],
        subject='data report',
        html_content='<strong>Data is processed as downloadable pdf - done by streamliner</strong>'
    )

    # with open('./report.pdf', 'rb') as f:
    #     data = f.read()
    #     f.close()
    # encoded_file = base64.b64encode(data).decode()

    # attachedFile = Attachment(
    #     FileContent(encoded_file),
    #     FileName('streamline - report.pdf'),
    #     FileType('application/pdf'),
    #     Disposition('attachment')
    # )
    # message.attachment = attachedFile
    # print(sys.argv[1])
    # #sg = SendGridAPIClient(sys.argv[1])
    # #response = sg.send(message)
    # #print(response.status_code, response.body, response.headers)
