% yy = plot_cheb_ldos(c,xx,ab)
%
% Given a set of first-kind Chebyshev moments, compute the associated
% density.   If no output argument is assigned, make a plot.
%
% Inputs:
%   c:  Array of Chebyshev moments (on [-1,1])
%   xx: evaluation points (defaults to mesh of 1001 pts)
%   ab: mapping parameters (defaults to identity)
%
% Output:
%   yy: Density evaluated at xx mesh (size nnodes-by-nmesh)
%   idx: Index for spectral re-ordering

function [yy,idx] = plot_chebhist_ldos(varargin)

  % Parse arguments
  [c,xx,xx0,ab] = plot_cheb_argparse(51, varargin{:});

  % Run the recurrence to compute CDF
  [nmoment, nnodes] = size(c);
  txx = acos(xx);
  yy = c(1,:)'*(txx-pi)/2;
  for np = 2:nmoment
    n = np-1;
    yy = yy + c(np,:)' * sin(n*txx)/n;
  end
  yy = -2/pi * yy;

  % Difference the CDF to compute histogram
  yy = yy(:,2:end)-yy(:,1:end-1);

  % Compute sorted histogram
  if nargout ~= 1
    [U,S,V] = svd(yy);
    [~,idx] = sort(U(:,1));
  end

  % Plot if appropriate
  if nargout < 1
    yr = [1, nnodes];
    xr = [xx0(1)+xx0(2), xx0(end-1)+xx0(end)]/2;
    imagesc(xr, yr, yy(idx,:));
    colormap default
    colorbar;
  end

end
