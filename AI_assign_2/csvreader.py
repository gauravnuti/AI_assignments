import csv

dists = {}

with open('roaddistance1.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    line_count = 0
    top_row = []
    for row in csv_reader:
        if line_count == 0:
            # print(row)
            top_row = row
            line_count += 1
        else:
            # print(f'\t{row[0]} works in the {row[1]} department, and was born in {row[2]}.')
            for i in range(1,len(row)):
                # print('dist(',row[0],',',top_row[i],',',row[i],')',sep='')
                l = [row[0],top_row[i]]
                l.sort()
                dists[l[0]+','+l[1]] = row[i]
                # if(row[0] in dists):
                #     dists[row[0]][top_row[i]] = row[i]
                # else:
                #     dists[row[0]] = {}
                #     dists[row[0]][top_row[i]] = row[i]
            line_count += 1

for i in dists:
    # print('dist(',i,',',dists[i]=)
    city = i.split(',')
    if(dists[i] == '-'):
        continue
    print('dists(',city[0].lower(),',',city[1].lower(),',',dists[i],').',sep='')
    print('dists(',city[1].lower(),',',city[0].lower(),',',dists[i],').',sep='')
    # break
    # print(f'Processed {line_count} lines.')

