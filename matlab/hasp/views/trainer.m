function varargout = trainer(varargin)
% TRAINER MATLAB code for trainer.fig
%      TRAINER, by itself, creates a new TRAINER or raises the existing
%      singleton*.
%
%      H = TRAINER returns the handle to a new TRAINER or the handle to
%      the existing singleton*.
%
%      TRAINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINER.M with the given input arguments.
%
%      TRAINER('Property','Value',...) creates a new TRAINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trainer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trainer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trainer

% Last Modified by GUIDE v2.5 01-May-2015 15:28:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @trainer_OpeningFcn, ...
                   'gui_OutputFcn',  @trainer_OutputFcn, ...
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


% --- Executes just before trainer is made visible.
function trainer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trainer (see VARARGIN)

% Choose default command line output for trainer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes trainer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trainer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenDataset_Callback(hObject, eventdata, handles)
% hObject    handle to OpenDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
