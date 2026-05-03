CLASS z_cvqxp_nn_main DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CLASS-METHODS xor_example
      IMPORTING !out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.


CLASS z_cvqxp_nn_main IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    xor_example( out = out ).
  ENDMETHOD.

  METHOD xor_example.
    " Constants
    DATA(lv_learning_rate) = CONV z_cvqxp_nn_types=>float( '0.01' ).
    DATA(lv_epochs) = 50000.
    DATA(lo_neural_network) = NEW z_cvqxp_nn_xor_wrapper(
                                      it_layers        = VALUE z_cvqxp_nn_neural_network=>ty_neural_network(
                                                                   ( NEW
                                                                     z_cvqxp_nn_layer_dense( iv_inputs_amt  = 2
                                                                                             iv_outputs_amt = 3 ) )
                                                                   ( NEW z_cvqxp_nn_layer_act_relu( ) )
                                                                   ( NEW
                                                                     z_cvqxp_nn_layer_dense( iv_inputs_amt  = 3
                                                                                             iv_outputs_amt = 1 ) )
                                                                   ( NEW z_cvqxp_nn_layer_act_sigmoid( ) ) )
                                      iv_learning_rate = lv_learning_rate ).
    " Try out the network before the training
    out->write( |Neural network XOR predictions before trainig: | ).
    DATA(lv_prediction) = lo_neural_network->predict( iv_boolean_1 = abap_false
                                                      iv_boolean_2 = abap_false ).
    out->write( |0 XOR 0 -> { lv_prediction } (Expected result: 0)| ).
    lv_prediction = lo_neural_network->predict( iv_boolean_1 = abap_true
                                                iv_boolean_2 = abap_false ).
    out->write( |1 XOR 0 -> { lv_prediction } (Expected result: 1)| ).
    lv_prediction = lo_neural_network->predict( iv_boolean_1 = abap_false
                                                iv_boolean_2 = abap_true ).
    out->write( |0 XOR 1 -> { lv_prediction } (Expected result: 1)| ).
    lv_prediction = lo_neural_network->predict( iv_boolean_1 = abap_true
                                                iv_boolean_2 = abap_true ).
    out->write( |1 XOR 1 -> { lv_prediction } (Expected result: 0)| ).

    " Do the training
    DO lv_epochs TIMES.
      lo_neural_network->train( iv_boolean_1      = abap_false
                                iv_boolean_2      = abap_false
                                iv_expected_value = abap_false ).
      lo_neural_network->train( iv_boolean_1      = abap_true
                                iv_boolean_2      = abap_false
                                iv_expected_value = abap_true ).
      lo_neural_network->train( iv_boolean_1      = abap_false
                                iv_boolean_2      = abap_true
                                iv_expected_value = abap_true ).
      lo_neural_network->train( iv_boolean_1      = abap_true
                                iv_boolean_2      = abap_true
                                iv_expected_value = abap_false ).

    ENDDO.
    out->write( |{ cl_abap_char_utilities=>newline }| ).
    out->write( |Did { lv_epochs } epochs of training on the XOR set.| ).
    out->write( |{ cl_abap_char_utilities=>newline }| ).

    " Try out the network after the training
    out->write( |Neural network XOR predictions after trainig: | ).
    lv_prediction = lo_neural_network->predict( iv_boolean_1 = abap_false
                                                iv_boolean_2 = abap_false ).
    out->write( |0 XOR 0 -> { lv_prediction } (Expected result: 0)| ).
    lv_prediction = lo_neural_network->predict( iv_boolean_1 = abap_true
                                                iv_boolean_2 = abap_false ).
    out->write( |1 XOR 0 -> { lv_prediction } (Expected result: 1)| ).
    lv_prediction = lo_neural_network->predict( iv_boolean_1 = abap_false
                                                iv_boolean_2 = abap_true ).
    out->write( |0 XOR 1 -> { lv_prediction } (Expected result: 1)| ).
    lv_prediction = lo_neural_network->predict( iv_boolean_1 = abap_true
                                                iv_boolean_2 = abap_true ).
    out->write( |1 XOR 1 -> { lv_prediction } (Expected result: 0)| ).
  ENDMETHOD.
ENDCLASS.