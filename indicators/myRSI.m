function RSI = myRSI(data, FTSName, timeframe, currency, period, OHLC, plotparam)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% myRSI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the Relative Strength Index of a given dataset
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
% period...The period of the RSI to be calculated
% calculation of the RSI
% OHLC...Abbreviation of the column that should be displayed in the plot
%  O...Opening Price
%  H...High Price
%  H...Low Price
%  H...Closing Price
% plotparam...Flag that decides if the plot should be plotted
% Outputs
% RSI...An array of the RSI for each given timestamp of the data starting
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
    
    RSI = zeros(s1, 1);
    profits = diff(data(:,5));

    
    for i=period+1:s1-1
        periodProfits = profits(i-period+1:i);
        avgProfit = mean(periodProfits(gains > 0));
        avgLoss = -mean(periodProfits(gains < 0));
    
        if isempty(avgProfit)
            avgProfit = 0;
        end
        if isempty(avgLoss)
            avgLoss = 0;
        end
    
        if avgLoss == 0
            RSI(i+1) = 100;
        else
            RS = avgProfit / avgLoss;
            RSI(i+1) = 100 - (100 / (1 + RS));
        end
    end


    if plotparam == 1
        figure
        ax1 = subplot(2,1,1);
        plot(v(period+1:end));
        title([FTSName, ': ',text,' and RSI period = ', num2str(period)]);
        xlabel(timeframe);
        ylabel(currency);

        ax2 = subplot(2,1,2);
        plot(RSI(period+1:end));
        grid minor;
        linkaxes([ax1, ax2], 'x')
    end

end