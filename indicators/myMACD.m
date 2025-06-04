function [MACD,EMAfaster,EMAslower,Signalline] = myMACD(data,FTSname, TimeFrame, Currency, faster,slower,signal,OHLC, plotparam)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% help myMACD     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% myMACD calculates Moving Average Convergence Divergence
% Inputs:
% data...... ....matrix (m*n) of real number, Date, 
%                Open, High,Low, Close.
% FTSname........string, name of FTS
% TimeFrame......Name of the Time Frame of the Data, e.g 'Daily',
%                'Weekly', '5 Min', ....
% Currency.......string, symbol of FTS
% faster.........Integer,  length of faster exp.moving average
% slower.........Integer,  length of slower exp.moving average, with slower > faster
% signal.........Integer,  length of signal line, i.e exp.moving average of
%                           difference:(slower ema - faster ema)
% OHLC...........string, "O" = Open,
%                        "H" = High,
%                        "L" = Low,
%                        "C" = Close.
% plotparam......boolean, if == 1 -> plot
%
% Outputs:
% MACD...........Vector,   vector of calculated MACD
% EMAfaster......Vector,   vector of calculated EMA with faster period
% EMAslower......Vector,   vector of calculated EMA with slower period
% Signalline.....Vector,   vector of calculated Signal line
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare data
if OHLC == "O"
    v = data(:,2);
    txt = 'Open Price';
elseif OHLC == "H"
    v = data(:,3);
    txt = 'High Price';
elseif OHLC == "L"
    v = data(:,4);
    txt = 'Low Price';
elseif OHLC == "C"   
    v = data(:,5);
    txt = 'Closing Price';
end

% Calculate MACD and Signalline
EMAfaster = myEMA(data, [], [],  [], faster, OHLC, 0);
EMAslower = myEMA(data, [], [],  [], slower, OHLC, 0);
t2 = length(data);
MACD = zeros(t2,1);
MACD(slower:end) = EMAfaster(slower:end)-EMAslower(slower:end);
tmp = MACD;
tmp(1:slower-1)  = [];
Signalline = myEMA(repmat(tmp,1,5),FTSname, [],  Currency, signal, OHLC, 0);
Signalline = [zeros(slower-1,1);Signalline];

% Plot Time Series with MACD
if plotparam == 1
    figure
    t1 = slower+signal;
    ax1 = subplot(2,1,1);
    plot(v(t1:end), 'b');
    xlabel(TimeFrame)
    ylabel(Currency)
    title([FTSname, ' : ', txt])
    grid minor
    ax2 = subplot(2,1,2);
    plot(MACD(t1:end), 'g');
    hold on;
    plot(Signalline(t1:end), 'r')
    MACDp = MACD(t1:end);
    Signallinep = Signalline(t1:end);
    aa = find(MACDp-Signallinep <= 0 );
    bb = find(MACDp-Signallinep > 0 );
    bar(aa ,MACDp(aa)-Signallinep(aa),'r')
    bar(bb,MACDp(bb)-Signallinep(bb),'g')
    grid minor
    xlabel(TimeFrame)
    ylabel(Currency)
    title(['MACD of ', txt,', faster = ',num2str(faster), ', slower = '...
          num2str(slower),', signal = ', num2str(signal)])
    linkaxes([ax1 ax2],'x')
end



