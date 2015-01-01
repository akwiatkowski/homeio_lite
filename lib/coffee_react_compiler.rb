class CoffeeReactCompiler
  def self.make_it_so(input_path: Padrino.root("app", "coffee_react_components", "*.cjsx"), output_path: Padrino.root("public", "javascripts", "compiled", "react_components.js"))
    coffee_string = ""
    Dir.glob(input_path) do |c|
      coffee_string += CoffeeReact.transform(File.open(c))
    end

    compiler = Barista::Compiler.new(coffee_string)
    #content = compiler.to_js

    Padrino.logger.debug("[CoffeeReactCompiler] Saving to #{output_path}")

    #File.delete(output_path) if File.exists?(output_path)
    compiler.save(output_path)
  end
end