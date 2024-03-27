*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
class zcl_earth DEFINITION.
PUBLIC SECTION.
METHODS start_engine RETURNING VALUE(r_value) TYPE string.
METHODS leave_orbit RETURNING VALUE(r_value) TYPE string.
ENDCLASS.

class zcl_earth IMPLEMENTATION.
  METHOD leave_orbit.
 r_value =  'we leave earth orbit'.
  ENDMETHOD.

  METHOD start_engine.
  r_value = 'we take off from palnet earth for mision takeoff'.

  ENDMETHOD.

ENDCLASS.

class zcl_planet1 DEFINITION.
PUBLIC SECTION.
METHODS enter_orbit RETURNING VALUE(r_value) TYPE string.
METHODS leave_orbit RETURNING VALUE(r_value) TYPE string.
ENDCLASS.
CLASS zcl_planet1 IMPLEMENTATION.
  METHOD leave_orbit.
  r_value = 'We leave planet1 orbit'.
  ENDMETHOD.

  METHOD enter_orbit.
  r_value = 'We enter planet1 orbit'.
  ENDMETHOD.

ENDCLASS.

class zcl_mars DEFINITION.
PUBLIC SECTION.
METHODS enter_orbit RETURNING VALUE(r_value) TYPE string.
METHODS explore_mars RETURNING VALUE(r_value) TYPE string.
ENDCLASS.
class zcl_mars IMPLEMENTATION.
  METHOD enter_orbit.
 r_value = 'We enter in mars orbit'.
  ENDMETHOD.

  METHOD explore_mars.
 r_value = 'Roget we foud the water'.
  ENDMETHOD.

ENDCLASS.
