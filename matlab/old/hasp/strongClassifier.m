function precence = strongClassifier(weaks, weights, threshold)
if ~isequal(size(weaks), size(weights))
    error('myfuns:strongClassifier:badArgument',...
    'Il vettore delle ipotesi e quello dei pesi devono essere ',...
    'della stessa lunghezza')
end

value = weaks * transpose(weights);
precence = value > threshold;
