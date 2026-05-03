"! <p class="shorttext synchronized">Class, which contains some types</p>
CLASS z_cvqxp_nn_types DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! float
    TYPES float                         TYPE float.
    "! list[float]
    TYPES list_of_float                 TYPE STANDARD TABLE OF z_cvqxp_nn_types=>float WITH EMPTY KEY.
    "! list[list[float]]
    TYPES list_of_list_of_float         TYPE STANDARD TABLE OF z_cvqxp_nn_types=>list_of_float WITH EMPTY KEY.
    "! list[list[list[float]]]
    TYPES list_of_list_of_list_of_float TYPE STANDARD TABLE OF z_cvqxp_nn_types=>list_of_list_of_float WITH EMPTY KEY.
ENDCLASS.


CLASS z_cvqxp_nn_types IMPLEMENTATION.
ENDCLASS.