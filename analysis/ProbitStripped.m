%   Probit.m
%
%   A program that fits a curve to data, using probit analysis. It's passed
%   3 variables: the stimuli values presented, the percentage of correct
%   responses, the number of stimuli presented per data collection session.
%   The last five parameters set the required window and subplot, choose 
%   whether you want to display the probit plot used in the calculation, 
%   what colour and style the measured data and fitted curve takes and the 
%   title to be displayed.
%
%   The program works by taking the percentages and converting them into 
%   probits. A straight line is fitted to these probits by least squares.
%   This fitted line is used to find expected probit values. The expected
%   probit values are used in Maximum Likelihood Estimation to improve the
%   fit of the line. Finally, the equation of the new fitted line gives a
%   set of probit values, from a range of stimuli values, which are plotted 
%   as a curve fitted to the experimental data.
%
%   Created by R. Woodhouse, using the book Probit Analysis by D.J. Finney (1971)
%
%   Initial version completed: 03/08/05
%
%   Precision and goodness of fit added: 18/05/06
%
%   Switching between 50%/75% and Chi squared table added: 14/06/06
%
%   Legend and title alterations made: 15/06/06 
%
% Modified by tom 19/6/07 to reduce graphical output and return
% 50 and 75% points plus chi-square and R-squared

function [fig, p50, p75, p84, chiSq, Rsq, D] = ProbitStripped(signal, pcCorrect, numstim, isPlot, asymptotes);

if nargin == 4
    asymptotes = [0.1 99.9];
end
for i = 1:length(pcCorrect);          % Ensures that the infinite probits
    if (pcCorrect(i) <= 0);           % of 0 and 100 don't occur
        pcCorrect(i) =  asymptotes(1);
    elseif (pcCorrect(i) == 100);
        pcCorrect(i) = asymptotes(2);
    end;
end;

%logsignal = log10(signal);
logsignal = signal;

probitvals = sqrt(2)*erfinv(2.*pcCorrect./100 - 1) + 5;   % Probit values

[m,c] = FitStraightProbitLine(logsignal, probitvals);   % Fits a straight line
FitY = m.*logsignal + c;                               

LSqY = FitY;

Check = 0;

while Check ~= 1
    [XBar,YBar,b,p50,p75,p84,chiSq,Var,Error,L,U] = MaxLikeEst(FitY,logsignal,pcCorrect,numstim);    % Uses maximum likelihood estimation
                                                                                           % to improve the fit of the line 
    RegressedY = YBar - b*XBar + b.*logsignal;   % Plots fitted line
    
    FitCheck = num2str(sum(FitY));
    RegCheck = num2str(sum(RegressedY));
       
    Check = strcmp(FitCheck,RegCheck);

    FitY = RegressedY;
end

% R-squared
expected = YBar - b*XBar + b.*logsignal;      % Finds probit values from MLE line
pcExpected = (FindP(expected - 5)).*100;       % Calculates percentages of above probits
rss = sum( (pcCorrect-pcExpected).^2 );	% residual sum-of-squares
mn  = mean( pcCorrect );
tss = sum( ( pcCorrect - mn ).^2 );     % total sum-of-squares
Rsq = 1 - rss / tss; 

% Wichman & Hill's deviamce meausure, code lifted from their Psignifit deviance.m
D = Deviance(logsignal, pcCorrect/100, numstim, pcExpected/100);

% for plotting
n = length(logsignal);
fitlogsignal = logsignal(1) :  (logsignal(n)-logsignal(1))/99 : logsignal(n);
RegressedProbits = YBar - b*XBar + b.*fitlogsignal;      % Finds probit values from MLE line
%         RegressedProbits = 5 + b.*fitlogsignal;      % Finds probit values from MLE line
ProbPerc = (FindP(RegressedProbits - 5)).*100;           % Calculates percentages of above probits

if isPlot
    fig = figure
    plot(fitlogsignal,ProbPerc,'k-', 'LineWidth', 2);
    hold on
    line([p50 p50],[0 50],'LineStyle', ':', 'linewidth', 2, 'color', 'k')
    line([logsignal(1) logsignal(n)], [50 50],'LineStyle',':');
    line([p75 p75],[0 75],'LineStyle',':', 'linewidth', 2, 'color', 'k')
    line([logsignal(1) logsignal(n)], [75 75],'LineStyle',':');
    line([p84 p84],[0 84],'LineStyle',':', 'linewidth', 2, 'color', 'r')
    line([logsignal(1) logsignal(n)], [84 84],'LineStyle',':');
    %plot(logsignal,pcCorrect,'ko','MarkerSize', 15, 'Markerfacecolor', 'k');
    plot(logsignal,pcCorrect, 'bo');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Finds the best fitting straight line using least squares

function [Grad, ICept] = FitStraightProbitLine(XAxis, YAxis);
    fittedParams = fminsearch(@LsError, [100 100], optimset, XAxis, YAxis); % was 0.1 0.1
    Grad  = fittedParams(1);
    ICept = fittedParams(2);
    
function sqrdErr = LsError(params, XAxis, YAxis);
	fittedYAxis = StraightLocal(XAxis, params);
	sqrdErr = sum( (fittedYAxis - YAxis).^2 );
    
function probability = StraightLocal(x, fitParams);
    probability =(fitParams(1).*x) + fitParams(2);

% Performs Maximum Likelihood Estimation, using weighting coefficients
% and working probits
    
function [XLine,YLine,Bee,p50,p75,p84,Chi,Var_PSE,Err,LowLim,UpLim] = MaxLikeEst(FittedY,XAx,YAx,NoStim);
    LeastNED = FittedY - 5;
    NEDP = FindP(LeastNED);
    NEDZ = FindZ(LeastNED);
    Weight = Weighting(NEDZ,NEDP);
    y0 = MinWorkProbit(FittedY,NEDZ,NEDP);
    y = WorkProbit(y0,YAx./100,NEDZ);

    NW = NoStim.*Weight;
    NWX = NW.*XAx;
    NWY = NW.*y;
    NWX2 = NWX.*XAx;
    NWXY = NWX.*y;
    NWY2 = NWY.*y;

    SigXX = sum(NWX2) - (sum(NWX))^2/sum(NW);
    SigXY = sum(NWXY) - (sum(NWX))*(sum(NWY))/sum(NW);
    SigYY = sum(NWY2) - (sum(NWY))^2/sum(NW);

    XLine = sum(NWX)/sum(NW);
    YLine = sum(NWY)/sum(NW);

    Bee = SigXY/SigXX;
    
    % tom modified this bit
    val50 = 5;
    val75 = 5.6745;
    val84 = 6; % ie 1 z-score away from 5
    p50 = (val50 - YLine + Bee*XLine)/Bee; 
    p75 = (val75 - YLine + Bee*XLine)/Bee; 
    p84 = (val84 - YLine + Bee*XLine)/Bee; 
        
    Chi = SigYY - ((SigXY)^2)/SigXX; % Calculates the chi squared value
    
    [Var_PSE,Err,LowLim,UpLim] = Precision(NW,Bee,p50,XLine,SigXX);
    
% Finds P, the probability from a N.E.D. or probit value (Probit = N.E.D. + 5)
    
function P = FindP(PNEDVal);
    P = 0.5*(1+erf(PNEDVal./sqrt(2)));

% Finds Z, the ordinate to the standardized normal frequency function 
% at the point corresponding the the N.E.D. 
    
function Z = FindZ(ZNEDVal);
    Z = (1/sqrt(2*pi))*exp(-0.5*(abs(ZNEDVal).^2));

% Finds w, the weighting function that weights the probit of probability P 
    
function w = Weighting(ZVal,PVal);
    w_Num = ZVal.^2;
    w_Denom = PVal.*(1-PVal);
    w = w_Num./w_Denom;

% Finds y0, the minimum working probit
    
function yMin = MinWorkProbit(Y,MinWorkZVal,MinWorkPVal);
    MinFrac = MinWorkPVal./MinWorkZVal;
    yMin = Y - MinFrac;

% Finds y, the working probit
    
function yWork = WorkProbit(MinWork,RelPerc,WorkZVal);
    WorkFrac = RelPerc./WorkZVal;
    yWork = MinWork + WorkFrac;

% Calculates the variance, standard error and Fiducial limits of the PSE
    
function [Variance,StdErr,LowerLimit,UpperLimit] = Precision(EnUU,B,PSE,XMean,SigmaXX) 
        
%----------------------------------------------------------------------
% These are rough estimates of precision - the Fiducial limits
% reported are more accurate
    
Variance = (B^-2)*(((sum(EnUU))^-1) + ((PSE-XMean)^2)/SigmaXX); % The variance
    
StdErr = (10^PSE)*(log(10))*(sqrt(Variance)); % The standard error on the original scale
    
%----------------------------------------------------------------------
    
G = 3.8416/((B^2)*SigmaXX);
    
A = PSE + (G*(PSE-XMean))/(1-G);
    
B1 = 1.96/(B*(1-G));
    
B2 = ((1-G)/sum(EnUU)) + (((PSE-XMean)^2)/SigmaXX);
    
LowerLimit = A - B1*sqrt(B2);   % The lower Fiducial limit
UpperLimit = A + B1*sqrt(B2);   % The upper Fuducial limit

% Wichman & Hill's deviance measure (pinched stright from their Deviance.m
% in psignifit

function D = Deviance(x,y,n,p);

    n = round(n);
    r = round(n .* y);
    w = n - r;
    y = r ./ n;

    residuals = 2 * (xlogy(r, y) + xlogy(w, 1-y) - xlogy(r, p) - xlogy(w, 1-p));
    residuals(residuals < 0) = 0; % can go negative due to precision errors
    D = sum(residuals, 2);
    if nargout >= 2,
        residuals = sign(y - p) .*sqrt(residuals);
    end

% additional function defined by Wichman & Hill

function a = xlogy(x, y)

    k = (y==0);
    y(k) = nan;
    y(x==0 & k) = 1;
    a = x.*log(y);
    k = isnan(y);
    a(k) = -sign(x(k)) * inf;
    
