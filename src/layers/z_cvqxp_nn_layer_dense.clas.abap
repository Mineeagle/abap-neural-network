"! <p class="shorttext synchronized">Dense Layer</p>
CLASS z_cvqxp_nn_layer_dense DEFINITION
  PUBLIC
  INHERITING FROM z_cvqxp_nn_layer FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! <p class="shorttext synchronized">Instantiate a dense layer</p>
    "! Instantiate a dense layer
    "! @parameter iv_inputs_amt  | <p class="shorttext synchronized">Inputs of the inputs vector</p>
    "! @parameter iv_outputs_amt | <p class="shorttext synchronized">Number values in the output vector</p>
    "! @parameter iv_seed        | <p class="shorttext synchronized">Seed used for initiation of the random values</p>
    METHODS constructor
      IMPORTING iv_inputs_amt  TYPE i
                iv_outputs_amt TYPE i
                iv_seed        TYPE i OPTIONAL.

    METHODS forward  REDEFINITION.

    METHODS backward REDEFINITION.

    "! Weights of the layer
    DATA mt_weights TYPE z_cvqxp_nn_types=>list_of_list_of_float.
    "! Biases of the layer
    DATA mt_biases  TYPE z_cvqxp_nn_types=>list_of_float.
    "! Seed used for the layer
    DATA mv_seed    TYPE i.
ENDCLASS.


CLASS z_cvqxp_nn_layer_dense IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    " Setup the seed
    mv_seed = COND i( WHEN iv_seed IS INITIAL
                      THEN sy-datum + sy-timlo * iv_outputs_amt + sy-timlo * iv_inputs_amt
                      ELSE iv_seed ).
    DATA(lo_random) = cl_abap_random=>create( seed = mv_seed ).
    " Initialize the weights
    DO iv_outputs_amt TIMES.
      DATA(lt_weight_row) = VALUE z_cvqxp_nn_types=>list_of_float( ).
      DO iv_inputs_amt TIMES.
        APPEND lo_random->decfloat34( ) TO lt_weight_row.
      ENDDO.
      APPEND lt_weight_row TO mt_weights.
    ENDDO.

    " Initialize the biases
    DO iv_outputs_amt TIMES.
      APPEND lo_random->decfloat34( ) TO mt_biases.
    ENDDO.
  ENDMETHOD.

  METHOD forward.
    " Store the inputs
    mt_inputs = it_inputs.

    " Calculate the dot product
    DATA(lt_dot_product) = VALUE z_cvqxp_nn_types=>list_of_float( ).
    LOOP AT mt_weights ASSIGNING FIELD-SYMBOL(<lt_weights>).
      DATA(lv_temporary_sum) = CONV z_cvqxp_nn_types=>float( 0 ).
      DO lines( it_inputs ) TIMES.
        lv_temporary_sum += it_inputs[ sy-index ] * <lt_weights>[ sy-index ].
      ENDDO.
      APPEND lv_temporary_sum TO lt_dot_product.
    ENDLOOP.

    " Add the bias
    DO lines( mt_biases ) TIMES.
      APPEND lt_dot_product[ sy-index ] + mt_biases[ sy-index ] TO rt_outputs.
    ENDDO.
  ENDMETHOD.

  METHOD backward.
    " Get the weight gradients
    DATA(lt_weight_gradient) = VALUE z_CVQXP_NN_TYPES=>list_of_list_of_float( ).
    LOOP AT it_output_gradient ASSIGNING FIELD-SYMBOL(<lv_single_output_gradient>).
      DATA(lt_temporary_weights_gradient) = VALUE z_CVQXP_NN_TYPES=>list_of_float( ).
      LOOP AT mt_inputs ASSIGNING FIELD-SYMBOL(<lv_input>).
        APPEND <lv_input> * <lv_single_output_gradient> TO lt_temporary_weights_gradient.
      ENDLOOP.
      APPEND lt_temporary_weights_gradient TO lt_weight_gradient.
    ENDLOOP.

    " Get the error with respect to the input
    DO lines( mt_weights[ 1 ] ) TIMES.
      DATA(lv_input_index) = sy-index.
      DATA(sum) = CONV z_cvqxp_nn_types=>float( 0 ).
      DO lines( mt_weights ) TIMES.
        DATA(lv_output_index) = sy-index.
        sum += mt_weights[ lv_output_index ][ lv_input_index ] * it_output_gradient[ lv_output_index ].
      ENDDO.
      APPEND sum TO rt_new_gradient.
    ENDDO.

    " Adapt bias
    DO lines( mt_biases ) TIMES.
      mt_biases[ sy-index ] -= iv_learning_rate * it_output_gradient[ sy-index ].
    ENDDO.

    " Adapt weights
    DATA(x) = 1.
    WHILE x <= lines( lt_weight_gradient ).
      DATA(y) = 1.
      WHILE y <= lines( lt_weight_gradient[ x ] ).
        mt_weights[ x ][ y ] -= iv_learning_rate * lt_weight_gradient[ x ][ y ].
        y += 1.
      ENDWHILE.
      x += 1.
    ENDWHILE.

    " Return error with respect to input
    RETURN rt_new_gradient.
  ENDMETHOD.
ENDCLASS.