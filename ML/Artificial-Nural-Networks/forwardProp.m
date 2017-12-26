%% Forward Propagation

function [output, hiddenOut] = forwardProp( input, model )
    hiddenOut = forward( input, model.in_weight, model.in_bias );
    output = forward( hiddenOut, model.out_weight, model.out_bias );
end

function [output] = forward( input, weight, bias )
    output = [input ones(size(input, 1),1)] * [weight; bias];
    output = 1./(1+exp(-output)); 
end