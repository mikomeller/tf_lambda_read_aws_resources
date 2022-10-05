def lambda_handler(event,context):
    print("Print from inside the function")
    print(context.function_name)