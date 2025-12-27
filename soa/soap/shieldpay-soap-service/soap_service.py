from spyne import Application, rpc, ServiceBase, Integer, Unicode
from spyne.protocol.soap import Soap11


class FraudSoapService(ServiceBase):

    @rpc(Integer, Integer, _returns=Unicode)
    def check_fraud(ctx, amount, risk_score):
        if amount > 10000 or risk_score > 70:
            return "FRAUD"
        return "CLEAN"


application = Application(
    [FraudSoapService],
    tns="spyne.shieldpay.soap",
    in_protocol=Soap11(validator="lxml"),
    out_protocol=Soap11()
)
