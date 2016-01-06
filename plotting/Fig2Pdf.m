function Fig2Pdf(fig,figname,figsize,res,offset)
% function Fig2Pdf(fig,figname,figsize,res,offset)
%
%FIG2PDF (v 0.2 - 28/01/2009)
% convert a matlab figure to a pdf file
% the pdf file is written in the current directory
%
%WARNING 
% you need to have the command line tool ps2pdf to use this function
% type 'ps2pdf' in a command window to check this tool is installed
% on your system
%
%USAGE: fig2pdf(FIG,FIGNAME,FIGSIZE,OFFSET)
% FIG handle of the figure to convert 
% FIGNAME name of the pdf figure (don't put the '.pdf' in the name)
%          default: 'myfig'
% FIGSIZE size of the pdf figure in pixels
%          default: current size of the fig file
% RES resolution of the figure (in dpi)
%          default: 300 => good quality (100 may be enough and requires less memory)
% OFFSET offset (in pixels) add/remove spaces around the original figure
%          default: [0 0]
%
%EXAMPLES: fig = figure; surf(randn(10)); shading flat
%          fig2pdf(fig,'fig1',[400 320],300,[0 0])
%          fig2pdf(fig,'fig2',[300 350],100,[50 -15])
%          then look at fig1.pdf and fig2.pdf in the current directory
%
%Author: Charles Verron (charles.verron@gmail.com)

if nargin < 1
    error('use at least one argument')
end
if nargin < 2
    figname = 'myfig';
end
if nargin < 3
    figsize = get(fig,'Position');
    figsize = [figsize(3) figsize(4)];
end
if nargin < 4
    res = 300;
end
if nargin < 5
    offset = [0 0];
end

set(fig, 'units', 'pixels');
set(fig, 'PaperType', '<custom>');
set(fig, 'PaperUnit', 'points');
set(fig, 'PaperPosition', [offset(1) offset(2) figsize]);
figsize = figsize+2*offset;
set(fig, 'PaperSize', figsize);
% offset sur l'origine si les labels des axes sont coupés?
% set(fig, 'PaperPosition', [5 5 figsize]); 
print(fig,'-depsc2',['-r' num2str(res)],[figname '.eps']);
system(sprintf('ps2pdf -g%dx%d %s.eps %s.pdf',figsize(1)*10,figsize(2)*10,figname,figname));
delete ([figname '.eps'])
%system(sprintf('del %s.eps',figname));
