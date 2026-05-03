"! <p class="shorttext synchronized">TanH activation layer</p>
CLASS z_cvqxp_nn_layer_act_tanh DEFINITION
  PUBLIC
  INHERITING FROM z_cvqxp_nn_layer_activate FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS activation         REDEFINITION.
    METHODS activation_inverse REDEFINITION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z_cvqxp_nn_layer_act_tanh IMPLEMENTATION.
  METHOD activation.
    rv_output_value = tanh( iv_input_value ).
  ENDMETHOD.

  METHOD activation_inverse.
    rv_output_value = 1 - tanh( iv_input_value ) ** 2.
  ENDMETHOD.
ENDCLASS.