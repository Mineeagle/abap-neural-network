"! <p class="shorttext synchronized">Neural Network class</p>
"! This class should be used as a blueprint, for other classes to inherit
"! from it, which are going to provide a sort of interface to the network.
"! <br>
"! For more information, please look at Z_CVQXP_NN_XOR_WRAPPER.
CLASS z_cvqxp_nn_neural_network DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    "! List of layers, which are used in the neural network
    TYPES ty_neural_network TYPE STANDARD TABLE OF REF TO z_cvqxp_nn_layer WITH EMPTY KEY.

    "! <p class="shorttext synchronized">Initiate a basic neural network</p>
    "! This call is a neural network, so basically an accumulation of multiple layers.
    "! @parameter it_layers        | <p class="shorttext synchronized">Table containing the different layers of the neural network</p>
    "! @parameter iv_learning_rate | <p class="shorttext synchronized">Learning rate, which is used during the training process</p>
    METHODS constructor
      IMPORTING it_layers        TYPE ty_neural_network
                iv_learning_rate TYPE z_cvqxp_nn_types=>float.

  PROTECTED SECTION.
    "! Table, which contains the layers of the network
    DATA mt_layers        TYPE ty_neural_network.
    "! The learning rate, when training the neural network
    DATA mv_learning_rate TYPE z_cvqxp_nn_types=>float.

    "! <p class="shorttext synchronized">Forward through the network</p>
    "! This method can be used by child classes to pass values through the network.
    "! @parameter it_input_values     | <p class="shorttext synchronized">Input vector</p>
    "! @parameter rt_predicted_values | <p class="shorttext synchronized">Output vector of the network</p>
    METHODS _predict
      IMPORTING it_input_values            TYPE z_cvqxp_nn_types=>list_of_float
      RETURNING VALUE(rt_predicted_values) TYPE z_cvqxp_nn_types=>list_of_float.

    "! <p class="shorttext synchronized">Forward and backward through the neural networi</p>
    "! This method can be used by child classes to train the neural network
    "! @parameter it_input_values       | <p class="shorttext synchronized">Input vector</p>
    "! @parameter it_expected_values    | <p class="shorttext synchronized">Expected output vector</p>
    "! @parameter rv_mean_squared_error | <p class="shorttext synchronized">Mean squared error of the prediction</p>
    METHODS _train
      IMPORTING it_input_values              TYPE z_cvqxp_nn_types=>list_of_float
                it_expected_values           TYPE z_cvqxp_nn_types=>list_of_float
      RETURNING VALUE(rv_mean_squared_error) TYPE z_cvqxp_nn_types=>float.
ENDCLASS.


CLASS z_cvqxp_nn_neural_network IMPLEMENTATION.
  METHOD constructor.
    mt_layers = it_layers.
    mv_learning_rate = iv_learning_rate.
  ENDMETHOD.

  METHOD _predict.
    rt_predicted_values = it_input_values.
    " Go forward through all the layers of the neural network
    LOOP AT mt_layers ASSIGNING FIELD-SYMBOL(<lo_layer>).
      rt_predicted_values = <lo_layer>->forward( it_inputs = rt_predicted_values ).
    ENDLOOP.
  ENDMETHOD.

  METHOD _train.
    " Forward pass
    DATA(lt_predicted_values) = it_input_values.
    LOOP AT mt_layers ASSIGNING FIELD-SYMBOL(<lo_layer>).
      lt_predicted_values = <lo_layer>->forward( it_inputs = lt_predicted_values ).
    ENDLOOP.

    " Calculate mse
    rv_mean_squared_error = z_cvqxp_nn_error=>mean_squared_error( it_expected_values  = it_expected_values
                                                                  it_predicted_values = lt_predicted_values ).
    " Backward aka training
    DATA(i) = lines( mt_layers ).
    DATA(lt_gradient_out) = z_cvqxp_nn_error=>mean_squared_error_gradient( it_expected_values  = it_expected_values
                                                                           it_predicted_values = lt_predicted_values ).
    WHILE i >= 1.
      DATA(lt_gradient_in) = lt_gradient_out.
      lt_gradient_out = mt_layers[ i ]->backward( it_output_gradient = lt_gradient_in
                                                  iv_learning_rate   = mv_learning_rate ).
      i -= 1.
    ENDWHILE.

    " Return the error rate
    RETURN rv_mean_squared_error.
  ENDMETHOD.
ENDCLASS.