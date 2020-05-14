#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 28 15:00:00 2019

@author: pengshi
"""

import numpy as np
import pandas as pd


def fileSetup(inputFile,outputFile):  
    try:
        schedule=pd.read_excel(outputFile,sheet_name='Schedule',header=[0,1,2],index_col=0).fillna(0).astype(int)
        summary=pd.read_excel(outputFile,sheet_name='Summary',index_col=0)
    except:
        print (f'Pandas could not read output file: {outputFile}')
        return False
    
    try:
        prefs=pd.read_excel(inputFile,sheet_name='Preferences',header=[0,1,2],index_col=0)
        q=pd.read_excel(inputFile,sheet_name='Requirements',index_col=0)
    except:
        print (f'Pandas could not read input file: {inputFile}')
        return False
    if prefs.shape==(9,21):
        inType='small_data'
    elif prefs.shape==(50,189):
        inType='data'
    else:
        print ("Error: Input file doesn't look like small_data.xlsx or data.xlsx!")
        return False
    if summary.shape!=(4,1):
        print ('Incorrect format of Summary sheet!')
        return False
    if set(summary.index)!={'Objective','Total preference score','Shift inequality','Night inequality'}:
        print ('Incorrect row labels in Summary sheet!')
        return False
    if summary.columns!=['Value']:
        print ('Incorrect column label of Summary sheet!')
        return False
    if schedule.shape!=prefs.shape:
        print ('Shape of Schedule table does not match up with input file!')
        return False
    return inType

def checkOptimality(outputFile,inType):
    summary=pd.read_excel(outputFile,sheet_name='Summary',index_col=0)['Value']
    try:
        if inType=='data':
            if float(summary.loc['Objective'])<3633:
                print ('Your objective is not optimal! An objective of 3633 is achievable for data.xlsx' )
                return False
        else:
            if float(summary.loc['Objective'])<-667:
                print ('Your objective is not optimal! An objective of -667 is achievable for small_data.xlsx' )
                return False
    except:
        return False
    return True

def checkSummaryStatistics(inputFile,outputFile):
    prefs=pd.read_excel(inputFile,sheet_name='Preferences',header=[0,1,2],index_col=0).values
    schedule=pd.read_excel(outputFile,sheet_name='Schedule',header=[0,1,2],index_col=0).fillna(0).astype(int).values
    summary=pd.read_excel(outputFile,sheet_name='Summary',index_col=0)['Value']
    totScore=np.sum(prefs*schedule)
    shifts=schedule.sum(axis=1)
    m=schedule.shape[1]
    nights=schedule[:,range(2,m,3)].sum(axis=1)
    shiftInequality=shifts.max()-shifts.min()
    nightInequality=nights.max()-nights.min()
    objval=totScore-100*shiftInequality-150*nightInequality
    if summary.loc['Total preference score']!=totScore:
        print('Total preference score in Summary sheet does not correspond to your schedule!')
        return False
    elif summary.loc['Shift inequality']!=shiftInequality:
        print('Shift inequality in Summary sheet does not correspond to your schedule!')
        return False
    elif summary.loc['Night inequality']!=nightInequality:
        print('Night inequality in Summary sheet does not correspond to your schedule!')
        return False
    elif summary.loc['Objective']!=objval:
        print('Objective is Summary sheet does not match what is calculated from the other fields!')
        return False
    return True

def checkFeasible(inputFile,outputFile):
    prefs=pd.read_excel(inputFile,sheet_name='Preferences',header=[0,1,2],index_col=0)
    J=prefs.columns.get_level_values(2)
    prefs.columns=J
    q=pd.read_excel(inputFile,sheet_name='Requirements',index_col=0)['persons']
    schedule=pd.read_excel(outputFile,sheet_name='Schedule',header=[0,1,2],index_col=0).fillna(0).astype(int)
    schedule.columns=J
    I=prefs.index
    m=len(J)
    for i in I:
        for j in J:
            if schedule.loc[i,j] not in {0,1}:
                print (f'Schedule for {i} in shift {j} is neither 0 nor 1!')
                return False
            if schedule.loc[i,j] and prefs.loc[i,j]==0:
                print (f'{i} is scheduled for shift {j}, which is blacked out!')
                return False
            if j+1<m and schedule.loc[i,j] and schedule.loc[i,j+1]:
                    print (f'{i} is scheduled to consecutive shifts {j} and {j+1}!')
                    return False

    for i in I:
        for j in range(2,m,3):
            if schedule.loc[i,j] and schedule.loc[i,j-2]:
                print (f'{i} is scheduled to night shift {j} and morning shift {j-2} of previous day!')
                return False
            if j+2<m and schedule.loc[i,j] and schedule.loc[i,j+2]:
                print (f'{i} is scheduled to night shift {j} and evening shift {j+2} of next day!')
                return False
    fulfilled=schedule.sum(axis=0)
    for j in J:
        if fulfilled.loc[j]!=q.loc[j]:
            print (f'{fulfilled.loc[j]} nurses are scheduled for shift {j}, which should have exactly {q.loc[j]} nurses!')
            return False

    for i in I:
        for w in range(m//21):
            shifts=schedule.loc[i,range(21*w,21*(w+1))].sum()
            if shifts>6:
                print(f'{i} is scheduled for more than 6 shifts in week from shift {21*w} to shift {21*(w+1)}')
                return False
    return True

if __name__=='__main__':
    import sys, os
    if len(sys.argv)!=3:
        print('Correct syntax: python grade_lab3.py outputFileGeneratedByYourCode inputFileFromCase')
    else:
        inputFile=sys.argv[2]
        outputFile=sys.argv[1]
        if not os.path.exists(inputFile):
            print (f'File "{inputFile}" not found!')
        elif not os.path.exists(outputFile):
            print (f'File "{outputFile}" not found!')
        else:
            inType=fileSetup(inputFile,outputFile)
            if inType=='data':
                print ('Grading schdule for full data...')
                points2=points3=points4=0
                if checkSummaryStatistics(inputFile,outputFile):
                    points2=1
                if checkFeasible(inputFile,outputFile):
                    points3=1
                if points2 and points3 and checkOptimality(outputFile,inType):
                    points4=1
                print('\nGrade for Lab 3:')
                print('ii) Correct Summary Stastics:',points2)
                print('iii) Feasible Schedule for Actual Data:',points3)
                print('iv) Optimal Schedule for Actual Data:',points4)
            elif inType=='small_data':
                print ('Checking your schedule for small_data...')
                if checkFeasible(inputFile,outputFile):
                    if checkSummaryStatistics(inputFile,outputFile):
                        if checkOptimality(outputFile,inType):
                            print ('Great, your solution for small_data is correct!')
                        else:
                            print('You have a feasible schedule but it is not optimal for small_data!')
                    else:
                        print ('ERROR: your calculation of summary statistics is wrong!')
                else:
                    print ('ERROR: your schedule is infeasible!')
            else:
                #print(f'{inputFile} is neither the data.xlsx or small_data.xlsx from the lab. Cannot proceed')
                print('Error with either the inputfile or outputfile. See above for details.')
            
                
