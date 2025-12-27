import grpc
from concurrent import futures
import transaction_pb2
import transaction_pb2_grpc


class TransactionService(transaction_pb2_grpc.TransactionServiceServicer):

    def ValidateTransaction(self, request, context):
        approved = request.amount < 1000
        reason = "Approved" if approved else "Amount too high"

        return transaction_pb2.TransactionResponse(
            approved=approved,
            reason=reason
        )


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    transaction_pb2_grpc.add_TransactionServiceServicer_to_server(
        TransactionService(), server
    )
    server.add_insecure_port("[::]:50051")
    server.start()
    print("gRPC Server running on port 50051")
    server.wait_for_termination()


if __name__ == "__main__":
    serve()
