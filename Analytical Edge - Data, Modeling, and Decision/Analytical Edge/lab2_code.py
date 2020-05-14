def optimize(inputFile, outputFile):
    import gurobipy as gb
    import pandas as pd
    data = pd.read_excel(inputFile, sheet_name=None)
    data['Demand'] = data['Demand'].drop('item_ID', axis=1)
    data['Distances'] = data['Distances'].drop('region_ID', axis=1)
    num_fc = len(data['Fulfilment Centers'])
    num_region = len(data['Regions'])
    num_item = len(data['Items'])
    mod = gb.Model()
    X = mod.addVars(num_fc, num_region, num_item)
    mod.setObjective(
        gb.quicksum(1.38 * data['Items'].loc[k, 'shipping_weight'] *
                    data['Distances'].iloc[j, i] * X[i, j, k]
                    for i in range(num_fc) for j in range(num_region)
                    for k in range(num_item)))
    capacity = mod.addConstrs((gb.quicksum(
        data['Items'].loc[k, 'storage_size'] * X[i, j, k]
        for j in range(num_region)
        for k in range(num_item)) <= data['Fulfilment Centers'].loc[i, 'capacity']
                               for i in range(num_fc)))
    mod.addConstrs(
        (gb.quicksum(X[i, j, k]
                     for i in range(num_fc)) >= data['Demand'].iloc[k, j]
         for j in range(num_region) for k in range(num_item)))
    mod.optimize()

    summary = pd.DataFrame([mod.objval], columns=['Objective Value'])

    FC_name = data['Fulfilment Centers']['FC_name']
    region_ID = data['Regions']['region_ID']
    item_ID = data['Items']['item_ID']
    solution_list = []
    for i in range(len(FC_name)):
        for j in range(len(region_ID)):
            for k in range(len(item_ID)):
                if X[i, j, k].X != 0:
                    solution_list.append([FC_name[i], region_ID[j], item_ID[k], X[i, j, k].X])
    solution = pd.DataFrame(solution_list, columns=['FC_name', 'region_ID', 'item_ID', 'shipment'])

    capacity_list = []
    for i in range(len(FC_name)):
        capacity_list.append([FC_name[i], capacity[i].pi])
    capacity_constr = pd.DataFrame(capacity_list, columns=['FC_name', 'shadow_price'])

    with pd.ExcelWriter(outputFile) as writer:
        summary.to_excel(writer, sheet_name='Summary', index=False)
        solution.to_excel(writer, sheet_name='Solution', index=False)
        capacity_constr.to_excel(writer, sheet_name='Capacity Constraints', index=False)

import sys
if __name__ == '__main__':
    optimize(sys.argv[1],sys.argv[2])