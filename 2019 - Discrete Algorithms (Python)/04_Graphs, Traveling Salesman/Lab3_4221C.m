%Abelardo Riojas
%ISC 4221C Lab 3
%Dr. Quaife, Fall 2019

fid = fopen('southamerica.grf');
str_line = 1;
line_count = 1;
while 1
    str_line = fgetl(fid); % read next line from the file
    if str_line ~= -1 % if str_line is not empty
        num_line = str2num(str_line);  % convert string to an array
        data(line_count) = {num_line};  % save the array into data
        line_count = line_count + 1;
    else % if str_line is empty, stop reading
        break
    end
end
fclose(fid);

data{1}; % get the first row

adjmatrix = adjMatrix(data);
edgelist = edgeList(data);
adjstructure = adjStruct(data,0);
incidence = incidenceMatrix(data);


A = adjmatrix;
v = [0 0 0 1 0 0 0 0 0 0 0 0]';
n = size(data,2);

for x = 1:n
    vn = (A^x)*v;
    if (vn(12) ~= 0)
        %disp([x, vn(12)])
        break
    end
end

vn = (A^8) * v;
%disp(vn(12));

fid = fopen('tsp.txt');
str_line = 1;
line_count = 1;
while 1
    str_line = fgetl(fid); % read next line from the file
    if str_line ~= -1 % if str_line is not empty
        num_line = str2num(str_line);  % convert string to an array
        tspdata(line_count) = {num_line};  % save the array into data
        line_count = line_count + 1;
    else % if str_line is empty, stop reading
        break
    end
end
fclose(fid);

tspadj = tspMatrix(tspdata);
fastest = [];
for i = 1:8
    [itin] = sortrows(itinerary(tspadj,8,i));
    fastest = [fastest; itin(1,:)];
end

disp(fastest(:,1))
function [permu] = itinerary(tspadj,nodes,home)
    myarray =  1:nodes;
    all_perms = perms(myarray);
    np = size(all_perms,1);
    all_perms = [ones(np,1).*home all_perms];
    permu = [];

    for x = 1:factorial(nodes)
        perm = all_perms(x,:);
        n = numel(perm);
        if perm(1) == perm(end)
            sum = 0;
            for i=1:n-1
                a = perm(i);
                b = perm(i+1);
                sum = sum + tspadj(a,b);
            end
            if sum < 10^10
            permu = [permu;sum perm];
            end
        end
        
    end
    
end

function matrix = tspMatrix(data)
    n = size(data,2);
    matrix = ones(n).*(10^10);
    for x = 1:n
        edge = data{x};
        matrix(edge(1),edge(2)) = edge(3);
        matrix(edge(2),edge(1)) = edge(3);
    end
end

function matrix = adjMatrix(data)
    n = size(data,2);
    matrix = zeros(n);
    for x = 1:n
        node = data{x};
        connections = node(4:end);
        for connection = connections
            matrix(x,connection) = 1;
        end
    end
end

function edgelist = edgeList(data)
    n = size(data,2);
    edgelist = [];
    for x = 1:n
        node = data{x};
        connections = node(4:end);
        for connection = connections
            edgelist = [edgelist;[x connection]];
        end
    end
    n = size(edgelist,1);
    for x = n:-1:1
        if (ismember(flip(edgelist(x,:)), edgelist, 'rows') == 1)
            edgelist(x,:) = [];
        end   
    end
end

function structure = adjStruct(data,display)
    n = size(data,2);
    structure = cell(n,1);
    for x = 1:n
        node = data{x};
        structure{x} = node(4:end);
    end
    if display == 1
        disp("adjstructure =")
        for x = 1:n
            disp(structure{x})
        end
    end
end

function incidence = incidenceMatrix(data)
    n = size(data,2);
    edgelist = [];
    for x = 1:n
        node = data{x};
        connections = node(4:end);
        for connection = connections
            edgelist = [edgelist;[x connection]];
        end
    end
    n = size(edgelist,1);
    for x = n:-1:1
        if (ismember(flip(edgelist(x,:)), edgelist, 'rows') == 1)
            edgelist(x,:) = [];
        end   
    end
    incidence = zeros(5);
    for x = 1:size(edgelist,1)
        incidence(x,edgelist(x,1)) = 1;
        incidence(x,edgelist(x,2)) = 1;
    end
end
