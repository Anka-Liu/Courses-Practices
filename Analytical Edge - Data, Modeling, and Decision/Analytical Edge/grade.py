#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 25 13:52:32 2019

@author: pengshi
"""
import sys
import os
import random, string
import pandas as pd

def checkFiles(scriptName):
    if not os.path.exists('small_data.xlsx'):
        print('Error: cannot find "small_data.xlsx" in current directory.')
        return False
    if not os.path.exists('data.xlsx'):
        print('Error: cannot find "data.xlsx" in current directory.')
        return False
    if not os.path.exists(scriptName):
        print(f'Error: cannot find {scriptName} in current directory.')
        return False
    return True

def randFilename():
    rand=''.join(random.SystemRandom().choice(string.ascii_uppercase + string.digits) for i in range(10))
    return 'tmp'+rand+'.xlsx'

def correctSampleOutput(filename):
    if not os.path.exists(filename):
        print('Did not create output file with given name')
        return False
    try:
        output=pd.read_excel(filename,sheet_name=None)
    except:
        print('Error in reading output file using Pandas.')
        return False
    if set(output.keys())!={'Summary', 'Solution', 'Capacity Constraints'}:
        print('Incorrect sheet names in output file.')
        return False
    if output['Summary'].shape!=(1,1):
        print('Incorrect format of "Summary" sheet.')
        return False
    try:
        objective=float(output['Summary'].iloc[0,0])
        if abs(objective-3400.76919)>0.1:
            print('Incorrect objective value')
            return False
    except:
        print('Error reading objective value')
        return False
    shadow=output['Capacity Constraints']
    if list(shadow.columns)!=['FC_name','shadow_price']:
        print('Incorrect column name of "Capacity Constraints" sheet.')
        return False
    shadow=shadow.set_index('FC_name')
    if set(shadow.index)!={'A','B'}:
        print('Incorrect indices of "Capacity Constraints" sheet.')
        return False
    try:
        A=float(shadow.loc['A','shadow_price'])
        B=float(shadow.loc['B','shadow_price'])
    except:
        print('Error reading shadow price entries in "Capacity Constraints" sheet.')
        return False
    if abs(A-0)>1e-3 or abs(B+0.6362076)>1e-3:
        print("Incorrect shadow prices")
        return False
    solution=output['Solution']
    if list(solution.columns)!=['FC_name','region_ID','item_ID','shipment']:
        print('Incorrect column names of "Solution" sheet.')
        return False
    if solution['shipment'].sum()!=1450:
        print('Incorrect answer in "Solution" sheet.')
        return False
    shipments=solution.groupby(['FC_name','region_ID','item_ID'])['shipment'].sum()
    ans={}
    ans['A',0,1]=125
    ans['A',1,0]=100
    ans['A',1,1]=200
    ans['A',2,1]=100
    ans['B',0,0]=500
    ans['B',0,1]=75
    ans['B',2,0]=350
    for FC,region,item in ans:
        if abs(shipments.loc[FC,region,item]-ans[FC,region,item])>1:
            print('Incorrect answer in "Solution" sheet.')
            return False
    return True

def correctFromCommandLine(scriptName):
    inputFile='small_data.xlsx'
    outputFile=randFilename()
    os.system(f'python {scriptName} {inputFile} {outputFile}')
    if os.path.exists(outputFile):
        ans=correctSampleOutput(outputFile)
        os.remove(outputFile)
    else:
        print('Script failed to produce outputfile')
        ans=False
    return ans 

def correctAsFunction(scriptName):
    try:
        module,ext=os.path.splitext(scriptName)
        module=module.replace('/','.')
        exec(f'import {module}',globals())
        exec(f'func={module}.optimize',globals())
    except:
        print('Cannot import function')
        return False
    inputFile='small_data.xlsx'
    outputFile=randFilename()
    try:
        func(inputFile,outputFile)
    except:
        print('Error executing the function')
        return False
    ans=correctSampleOutput(outputFile)
    os.remove(outputFile)
    return ans

if __name__=='__main__':
    
    if len(sys.argv)!=2:
        print('''Incorrect usage. You need to specify exactly one argument, 
              which is the filename of the script to be graded.''')
    else:
        scriptName=sys.argv[1]
        if checkFiles(scriptName):
            point1=correctAsFunction(scriptName)*1
            point2=correctFromCommandLine(scriptName)*1
            print(f'\nAutograding Lab 2 script named "{scriptName}":')
            print('\n\tCorrect from function call:',point1)
            print('\tCorrect from command line:',point2)
            print(f'\nTotal code score (out of 2):',point1+point2)
            
    
    
            
    