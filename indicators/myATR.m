function ATR = myATR(data, FTSName, timeframe, currency, period, OHLC, plotparam)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% myATR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the Average True Range of a given dataset
% Inputs
% data...The dataset containing five columns in the following order
%  1. Timestamp
%  2. Opening Price
%  3. High Price
%  4. Low Price
%  5. Closing Price
% FTSName...The name of the dataset (e.g. name of the stock)
% timeframe...The timeframe of the data (e.g. hourly, daily, weekly,...)
% currency...The Currency of the price values
% period...The period of the ATR to be calculated
% OHLC...Abbreviation of the column that should be displayed in the plot
%  O...Opening Price
%  H...High Price
%  H...Low Price
%  H...Closing Price
% plotparam...Flag that decides if the plot should be plotted
% Outputs
% ATR...An array of the ATR for each given timestamp of the data starting
% from the period element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if OHLC == "O"
        v = data(:,2);
        text = 'Open Price';
    elseif OHLC == "H"
        v = data(:,3);
        text = 'High Price';
    elseif OHLC == "L"
        v = data(:,4);
        text = 'Low Price';
    elseif OHLC == "C"
        v = data(:,5);
        text = 'Closing Price';
    end

    [s1,~] = size(data);
    
    High = data(:,3);
    Low = data(:,4);
    Close = data(:,5);

    ATR = zeros(s1, 1);
    TR = zeros(s1, 1);
    TR(1) = High(1) - Low(1); 
    
    for i = 2:s1
        TR(i) = max([ ...
            High(i) - Low(i), ...
            abs(High(i) - Close(i-1)), ...
            abs(Low(i) - Close(i-1)) ...
        ]);
    end

    
    for i=period:s1
        ATR(i) = mean(TR(i-period+1:i));
    end
    
    if plotparam == 1
        figure
        ax1 = subplot(2,1,1);
        plot(v(period:end));
        title([FTSName, ': ',text,' and ATR period = ', num2str(period)]);
        xlabel(timeframe);
        ylabel(currency);

        ax2 = subplot(2,1,2);
        plot(ATR(period:end));
        grid minor;
        linkaxes([ax1, ax2], 'x')
    end

end