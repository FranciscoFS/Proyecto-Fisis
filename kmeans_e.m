function [I_out] = kmeans_e(I,k,alpha)

    [M,~] = size(I);
    [Y,X] = meshgrid(1:M,1:M);
    Features = [Bft_norm(double(I(:)),0) alpha*Bft_norm(Y(:),0) alpha*Bft_norm(X(:),0)];
    Clusters = kmeans(Features,k,'MaxIter',1000);
    I_out = reshape(Clusters,M,M);
    
end
    