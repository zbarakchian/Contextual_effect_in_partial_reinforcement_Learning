function sbjs = get_all_sbjs(ftype)

switch ftype
    case 'Partial'
        sbjs = [1:41];

    case 'Complete'
        sbjs = [1:47];
end