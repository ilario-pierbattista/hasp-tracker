pattern = [
1 2;
3 4;
];

blob1 = [
1 2;
3 4;
];

blob2 = [0 1 0 0;
1 1 2 0;
3 3 4 0;
0 1 0 1];

blob3 = [0 1 0 0;
1 2 0 1;
3 4 0 1;
0 1 0 1];

coordinates = search_blob_pattern(blob1, pattern);
assert(isequal(coordinates, [1 1]));

coordinates = search_blob_pattern(blob2, pattern);
assert(isequal(coordinates, [2 2]));

coordinates = search_blob_pattern(blob3, pattern);
assert(isequal(coordinates, [2 1]));

fprintf('Test eseguiti con successo\n');
