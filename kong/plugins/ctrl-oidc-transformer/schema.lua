return {

  no_consumer = true,

  fields = {

    input_header_name = { type = "string", required = true },
    is_input_header_base64 = { type = "boolean", default=true, required = true },
    output_header_prefix = { type = "string", required = true }

  }

}