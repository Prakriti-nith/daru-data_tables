require_relative 'param_helpers'

module Daru
  module DataTables
    module JsHelpers
      include Daru::DataTables::ParamHelpers

      # Generates JavaScript function for rendering the Table.
      #
      # Parameters:
      #  *element_id            [Required] The ID of the DIV element that the DataTable should be rendered in.
      def draw_js(element_id)
        data_array = options.delete(:data) unless options[:data].nil?
        draw_ajax_option
        js = ''
        js << "\n$(document).ready(function() {"
        js << "\n"
        js << "\n\tvar data_array = #{data_array};"
        js << "\n\t$('##{element_id}').DataTable("
        js << "\n\t\t#{js_parameters(@options)}"
        js << "\n\t);"
        js << "\n"
        js << "\n});"
        js
      end

      def draw_js_iruby(element_id)
        data_array = options.delete(:data) unless options[:data].nil?
        draw_ajax_option
        js = ''
        js << "\n$( function () {"
        js << "\n\tvar data_array = #{data_array};"
        js << "\n\tvar table = $('##{element_id}').DataTable("
        js << "\n\t\t#{js_parameters(@options)}"
        js << "\n\t);"
        js << "\n"
        js << "\n});"
        js
      end

      def draw_ajax_option
        ajax_str = ''
        ajax_str << "\nfunction ( data, callback, settings ) {"
        ajax_str << "\n\tvar out = [];"
        ajax_str << "\n\tfor (var i=data.start; i<data.start+data.length; i++) {"
        ajax_str << "\n\t\tif (i < data_array.length) {"
        ajax_str << "\n\t\t\tout.push( data_array[i] );"
        ajax_str << "\n\t\t}"
        ajax_str << "\n\t}"
        ajax_str << "\n\tsetTimeout( function () {"
        ajax_str << set_callback_ajax
        ajax_str << "\n\t}, 50 );"
        ajax_str << "\n}"
        @options[:serverSide] = true
        @options[:ajax] = ajax_str.js_code
      end

      def set_callback_ajax
        callback_js = ''
        callback_js << "\n\t\tcallback( {"
        callback_js << "\n\t\t\tdraw: data.draw,"
        callback_js << "\n\t\t\tdata: out,"
        callback_js << "\n\t\t\trecordsTotal: data_array.length,"
        callback_js << "\n\t\t\trecordsFiltered: data_array.length,"
        callback_js << "\n\t\t} );"
        callback_js
      end
    end
  end
end
