import logging
from html.parser import HTMLParser
import azure.functions as func
import urllib
  
class MyHTMLParser(HTMLParser):
     # parameterized constructor 
    def __init__(self, s, e, d): 
        self.startTag = s
        self.endTag = e
        self.data = d
        super(MyHTMLParser, self).__init__()

    def handle_starttag(self, tag, attrs):
        self.startTag = self.startTag + 1

    def handle_endtag(self, tag):
        self.endTag = self.endTag + 1

    def handle_data(self, data):
        self.data = self.data + 1

def main(req: func.HttpRequest) -> func.HttpResponse:
    parser = MyHTMLParser(0, 0, 0)
    body = urllib.parse.unquote(req.get_body().decode("utf-8")).replace("+", " ")
    parser.feed(body)
    parser.close()
    print(f"StartTagCount: {parser.startTag} endTagCount: {parser.endTag} dataCount: {parser.data}")
    return func.HttpResponse(
            f"StartTagCount: {parser.startTag} endTagCount: {parser.endTag} dataCount: {parser.data}",
             status_code=200
        )
        
