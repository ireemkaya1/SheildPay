from wsgiref.simple_server import make_server
from spyne.server.wsgi import WsgiApplication
from soap_service import application


if __name__ == "__main__":
    server = make_server(
        "127.0.0.1",
        8000,
        WsgiApplication(application)
    )
    print("SOAP servis çalışıyor:")
    print("http://127.0.0.1:8000/?wsdl")
    server.serve_forever()
