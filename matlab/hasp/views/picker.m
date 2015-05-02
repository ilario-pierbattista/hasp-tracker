function varargout = picker(varargin)
% PICKER MATLAB code for picker.fig
%      PICKER, by itself, creates a new PICKER or raises the existing
%      singleton*.
%
%      H = PICKER returns the handle to a new PICKER or the handle to
%      the existing singleton*.
%
%      PICKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PICKER.M with the given input arguments.
%
%      PICKER('Property','Value',...) creates a new PICKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before picker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to picker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help picker

% Last Modified by GUIDE v2.5 30-Apr-2015 08:44:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @picker_OpeningFcn, ...
                   'gui_OutputFcn',  @picker_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before picker is made visible.
function picker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to picker (see VARARGIN)

% Choose default command line output for picker
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes picker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = picker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function pathTextField_Callback(hObject, eventdata, handles)
% hObject    handle to pathTextField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathTextField as text
%        str2double(get(hObject,'String')) returns contents of pathTextField as a double


% --- Executes during object creation, after setting all properties.
function pathTextField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathTextField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseButton.
function browseButton_Callback(hObject, eventdata, handles)
% hObject    handle to browseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = uigetdir();
if path ~= 0
    set(handles.pathTextField, 'String', path);
end


% --- Executes on button press in enterButton.
function enterButton_Callback(hObject, eventdata, handles)
% hObject    handle to enterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
path = get(handles.pathTextField, 'String');
if exist(path) ~= 7
    'Cartella non esistente'
end



function heightTextField_Callback(hObject, eventdata, handles)
% hObject    handle to heightTextField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heightTextField as text
%        str2double(get(hObject,'String')) returns contents of heightTextField as a double


% --- Executes during object creation, after setting all properties.
function heightTextField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heightTextField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function widthTextField_Callback(hObject, eventdata, handles)
% hObject    handle to widthTextField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of widthTextField as text
%        str2double(get(hObject,'String')) returns contents of widthTextField as a double


% --- Executes during object creation, after setting all properties.
function widthTextField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to widthTextField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cancButton.
function cancButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

