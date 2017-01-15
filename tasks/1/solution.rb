def convert_between_temperature_units(degrees, degrees_unit, converted_unit)

  units = "#{degrees_unit}#{converted_unit}"

  hash_temp_converter = {
    'CK' => degrees + 273.15,
    'KC' => degrees - 273.15,
    'CF' => degrees * 1.8 + 32,
    'FC' => (degrees - 32) / 1.8,
    'KF' => degrees * 9 / 5 - 459.67,
    'FK' => (degrees + 459.67) * 5 / 9
  }

  hash_temp_converter[units] ? hash_temp_converter[units].round(5) : degrees
end

def melting_point_of_substance(substance, degrees_unit)

  hash_melting_point_celsius = {
    'water' => 0,
    'ethanol' => -114,
    'gold' => 1064,
    'silver' => 961.8,
    'copper' => 1085
  }

  convert_between_temperature_units(hash_melting_point_celsius[substance], 'C', degrees_unit)

end

def boiling_point_of_substance(substance, degrees_unit)

  hash_boiling_point_celsius = {
    'water' => 100,
    'ethanol' => 78.37,
    'gold' => 2700,
    'silver' => 2162,
    'copper' => 2567
  }

  convert_between_temperature_units(hash_boiling_point_celsius[substance], 'C', degrees_unit)

end
