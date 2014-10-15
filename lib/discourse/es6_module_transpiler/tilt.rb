require 'tilt'
require 'discourse/es6_module_transpiler/tilt/es6_module_transpiler_template'

Tilt.register Tilt::ES6ModuleTranspilerTemplate, 'es6'
