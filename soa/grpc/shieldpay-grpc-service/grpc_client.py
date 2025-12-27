import grpc
import transaction_pb2
import transaction_pb2_grpc


def run():
    channel = grpc.insecure_channel("localhost:50051")
    stub = transaction_pb2_grpc.TransactionServiceStub(channel)

    response = stub.ValidateTransaction(
        transaction_pb2.TransactionRequest(
            amount=1500,
            currency="USD"
        )
    )

    print("Approved:", response.approved)
    print("Reason:", response.reason)


if __name__ == "__main__":
    run()
