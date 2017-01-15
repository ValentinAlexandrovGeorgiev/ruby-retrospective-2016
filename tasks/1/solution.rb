
MELTING_POINTS_CELSIUS = {
  'water' => 0,
  'ethanol' => -114,
  'gold' => 1_064,
  'silver' => 961.8,
  'copper' => 1_085,
}
BOILING_POINTS_CELSIUS = {
  'water' => 100,
  'ethanol' => 78.37,
  'gold' => 2_700,
  'silver' => 2_162,
  'copper' => 2_567,
}


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

  hash_temp_converter[units] ? hash_temp_converter[units] : degrees
end

def melting_point_of_substance(substance, degrees_unit)

  convert_between_temperature_units(MELTING_POINTS_CELSIUS[substance], 'C', degrees_unit)

end

def boiling_point_of_substance(substance, degrees_unit)

  convert_between_temperature_units(BOILING_POINTS_CELSIUS[substance], 'C', degrees_unit)

end
