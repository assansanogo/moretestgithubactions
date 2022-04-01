import os
import glob2
import base64
import pdfkit
import sys

from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import (Mail, Attachment, FileContent, FileName, FileType, Disposition)

if __name__=='__main__':
    
    # sys.argv[1] : SENDGRID
    # sys.argv[2] : sender
    # sys.argv[3] : destinatary
    # sys.argv[4] : path of the daily report computed by streamline
    
    print(os.listdir("out/data/US"))
    print(sys.argv)
    
    
    # pdfkit additional config (path tobinary wkhtmltopdf)
    # conversion csv to pdf
    # TODO : embellify/prettify pdf use argparse
    
    config = pdfkit.configuration(wkhtmltopdf='/usr/bin/wkhtmltopdf')
    report_csv_filename = ("/").join(sys.argv[4].split("/")[-4:])
   
    print(report_csv_filename)
    report_pdf_filename = report_csv_filename.replace(".csv",".pdf")
   
    # pdf creation (from csv)
    pdfkit.from_file(report_csv_filename, 
                     report_pdf_filename , 
                     configuration=config)


    # create SENDGRID email object
    message = Mail(
        from_email=sys.argv[2],
        to_emails=sys.argv[3],
        subject='data report',
        html_content='<strong>Data is processed as downloadable pdf - done by streamliner</strong>'
    )

    #  create the pdf report
    #  data must be encoded to be used by SENDGRID 
    
    with open('custom_report.pdf', 'rb') as f:
         data = f.read()
         f.close()
    encoded_file = base64.b64encode(data).decode()

    attachedFile = Attachment(
         FileContent(encoded_file),
         FileName('streamline - JH report.pdf'),
         FileType('application/pdf'),
         Disposition('attachment')
     )
    
    # send message with the the SENDGRID api key.
    # passed via Github secrets
    message.attachment = attachedFile
    sg = SendGridAPIClient(sys.argv[1])
    response = sg.send(message)
    print(response.status_code, response.body, response.headers)
