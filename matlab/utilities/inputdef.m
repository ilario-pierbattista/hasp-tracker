function data = inputdef(prompt, default, string);
    % inputdef Migliora la funzionalità di matlab 'input', permettendo di specificare un parametro di default
    % Example:
    %   foo = inputdef('Inserire foo [%s]: ', 'bar', 's') Chiede in input una stringa, assegnando 'bar' di default

    prompt = sprintf(prompt, default);
    if isempty(string)
        data = input(prompt);
    else
        data = input(prompt, string);
    end
    if isempty(data)
        data = default;
    end
end
