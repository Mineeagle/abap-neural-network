"! <p class="shorttext synchronized">Sigmoid activation layer</p>
CLASS z_cvqxp_nn_layer_act_relu DEFINITION
  PUBLIC
  INHERITING FROM z_cvqxp_nn_layer_activate FINAL
  CREATE PUBLIC.

  PROTECTED SECTION.
    METHODS activation         REDEFINITION.
    METHODS activation_inverse REDEFINITION.

ENDCLASS.


CLASS z_cvqxp_nn_layer_act_relu IMPLEMENTATION.
  METHOD activation.
    " Calculate the relu value
    rv_output_value = COND #( WHEN 0 >= iv_input_value THEN 0 ELSE iv_input_value ).
  ENDMETHOD.

  METHOD activation_inverse.
    " Calculate the inverse of the relu
    rv_output_value = COND #( WHEN iv_input_value >= 0 THEN 1 ELSE 0 ).
  ENDMETHOD.
ENDCLASS.