class CommandParser
  attr_accessor :cmd_name

  def initialize(cmd_name)
    @cmd_name = cmd_name
    @arg_blocks = []
    @opt_blocks = []
    @opt_param_blocks = []
    @args = []
    @options = []
    @options_param = []
  end

  def argument(arg, &arg_block)
    @arg_blocks.push(arg_block)
    arg = arg.insert(0, '[').insert(-1, ']')
    @args.push(arg)
  end

  def option(short_option, option, text, &opt_block)
    @opt_blocks.push(opt_block)

    @options.push([short_option.insert(0, '-'), option.insert(0, '--'), text])

  end

  def option_with_parameter(short_param, opt_p, text, pl, &opt_param_block)
    @opt_param_blocks.push(opt_param_block)
    param = [short_param.insert(0, '-'), opt_p.insert(0, '--'), text, pl]
    @options_param.push(param)
  end

  def parse(command_runner, argv)
    argv.each do |arg|
      if option? arg
        call_block(@opt_blocks, command_runner, true)
      elsif arg.start_with?("-")
        call_block(@opt_param_blocks, command_runner, convert_param(arg))
      else
        call_block(@arg_blocks, command_runner, arg)
      end
    end
  end

  def call_block(blocks, command_runner, arg)
    unless blocks.empty?
      blocks.first.call(command_runner, arg)
      blocks.shift
    end
  end

  def help
    args_doc = "Usage: #{cmd_name} #{@args.join(" ")}\n" unless @args.empty?
    opts_doc = ""
    opts_params_doc = ""
    @options.map { |opt| opts_doc << "    #{opt[0]}, #{opt[1]} #{opt[2]}\n" }
    @options_param.map do |opt|
      opts_params_doc << "    #{opt[0]}, #{opt[1]}=#{opt[3]} #{opt[2]}\n"
    end
    args_doc << opts_doc << opts_params_doc
  end

  def convert_param(arg)
    arg.start_with?("--") ? arg.split("=")[1] : arg[2..-1]
  end

  def option?(arg)
    short_option = arg.start_with?("-") && arg.size == 2
    long_option = arg.start_with?("--") && !arg.include?("=")
    short_option || long_option
  end
end
