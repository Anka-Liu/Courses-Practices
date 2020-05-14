def optimize(inputFile, outputFile):
    """
    This function intakes excel file containing two sheets "Courses" and "Classroom", and optimize the best course
    schedule for USC Marshall courses and classrooms.

    input:
    inputFile: an Excel file containing two sheets "Courses" and "Classroom"
                "Courses" sheet must contain the following columns:
                course: course name
                section: section of the course
                units: the units of course must specify how many slots are needed
                seats_offered: the number of students to take in
                A,B,C: the preferences of courses in {1,2,3,4}

                "Classrooms" sheet must contain the following columns:
                Room: the name of classroom
                Size: the available seats of the classroom

    output:
    none, an csv file outputFile will be written to the current directory
    """
    # Use Gurobi Python API as the optimization engine
    import pandas as pd
    import gurobipy as gp

    # Read the specified excel, with two sheets of courses and classrooms
    courses = pd.read_excel(inputFile, sheet_name='Courses')
    classrooms = pd.read_excel(inputFile, sheet_name='Classrooms')

    #Build optimization model
    mod = gp.Model()

    # The decision variables
    X = mod.addVars(len(courses), len(classrooms), 7, 5, vtype=gp.GRB.BINARY)
    H = mod.addVars(len(courses), vtype=gp.GRB.BINARY)
    A = mod.addVars(len(courses), vtype=gp.GRB.BINARY)
    B = mod.addVars(len(courses), vtype=gp.GRB.BINARY)
    C = mod.addVars(len(courses), vtype=gp.GRB.BINARY)

    # The relevant data
    m = courses['seats_offered']
    n = classrooms['Size']
    s = courses['units']
    a = courses['A']
    b = courses['B']
    c = courses['C']
    I = len(courses)
    J = len(classrooms)

    # Set objective goal
    obj = mod.setObjective(4 * gp.quicksum(X[i, j, k, w] * m[i] / (s[i] * n[j])
                                           for i in range(I) for j in range(J)
                                           for k in range(7) for w in range(5)) +
                           gp.quicksum(
                               a[i] * A[i] + b[i] * B[i] + c[i] * C[i] + 4 * H[i]
                               for i in range(I)))

    # add first constraint of Classroom space limit
    mod.addConstrs(m[i] * X[i, j, k, w] <= n[j] * X[i, j, k, w] for i in range(I) for j in range(J)
                        for k in range(7) for w in range(5))

    # add second constraint of no course conflict
    mod.addConstrs(
        gp.quicksum(X[i, j, k, w] for i in range(I)) <= 1 for j in range(J)
        for k in range(7) for w in range(5))

    # add third constraint of course units/required slots
    mod.addConstrs(
        gp.quicksum(X[i, j, k, w] for j in range(J) for k in range(7)
                    for w in range(5)) == s[i] for i in range(I))

    # add fourth constraint of satisfying Mon-Wed or Tue-Thu positions for courses
    # the temp variables are to store the boolean values for conditional relationships
    # This represents the difference of seleted or not between Mon-Wed or Tue-Thu positions
    temp1 = mod.addVars(I, J, 7, 2)
    # This represents the absolute value of difference above
    temp1_c = mod.addVars(I, J, 7, 2)
    # this represents whether Mon-Wed or Tue-Thu positions are selected together
    temp1_r = mod.addVars(I, J, 7, 2)
    # this represents whether all time slots satisfy the condition
    mod.addConstrs(temp1[i, j, k, w] == X[i, j, k, w] - X[i, j, k, w + 2]
                   for i in range(I) for j in range(J) for k in range(7)
                   for w in range(2))

    mod.addConstrs(temp1_c[i, j, k, w] == gp.abs_(temp1[i, j, k, w])
                   for i in range(I) for j in range(J) for k in range(7)
                   for w in range(2))

    mod.addConstrs(1 - temp1_r[i, j, k, w] == temp1_c[i, j, k, w]
                   for i in range(I) for j in range(J) for k in range(7)
                   for w in range(2))

    mod.addConstrs(H[i] == gp.and_(temp1_r[i, j, k, w] for j in range(J)
                                   for k in range(7) for w in range(2)) for i in range(I))
    # that Mon-Wed or Tue-Thu positions are selected together.

    # add fifth constraint of satisfying courses between 10am and 6pm
    # the temp variables are to store the boolean values for conditional relationships
    # represent whether the time slots outside 10am - 6pm are not selected
    temp3 = mod.addVars(I, J, 3, 5)
    # the constraint is expanded due to processing of conditions
    mod.addConstrs(temp3[i, j, 0, w] == 1 - X[i, j, 0, w] for i in range(I) for j in range(J) for w in range(5))
    mod.addConstrs(temp3[i, j, 1, w] == 1 - X[i, j, 5, w] for i in range(I) for j in range(J) for w in range(5))
    mod.addConstrs(temp3[i, j, 2, w] == 1 - X[i, j, 6, w] for i in range(I) for j in range(J) for w in range(5))
    # this is the final abstract conclusion of constraint
    mod.addConstrs(A[i] == gp.and_(temp3[i, j, k, w] for j in range(J)
                                   for k in range(3) for w in range(5))
                   for i in range(I))

    # add sixth constraint of satisfying courses on Mon and Wed
    # the temp variables are to store the boolean values for conditional relationships
    # represent whether the time slots outside Mon and Wed are not selected
    temp4 = mod.addVars(I, J, 7, 3)
    # the constraint is expanded due to processing of conditions
    mod.addConstrs(temp4[i, j, k, 0] == 1 - X[i, j, k, 1] for i in range(I) for j in range(J) for k in range(7))
    mod.addConstrs(temp4[i, j, k, 1] == 1 - X[i, j, k, 3] for i in range(I) for j in range(J) for k in range(7))
    mod.addConstrs(temp4[i, j, k, 2] == 1 - X[i, j, k, 4] for i in range(I) for j in range(J) for k in range(7))
    # this is the final abstract conclusion of constraint
    mod.addConstrs(B[i] == gp.and_(temp4[i, j, k, w] for j in range(J)
                                   for k in range(7) for w in range(3))
                   for i in range(I))

    # add seventh constraint of satisfying courses on Tue and Thu
    # the temp variables are to store the boolean values for conditional relationships
    # represent whether the time slots outside Tue and Thu are not selected
    temp5 = mod.addVars(I, J, 7, 3)
    # the constraint is expanded due to processing of conditions
    mod.addConstrs(temp5[i, j, k, 0] == 1 - X[i, j, k, 0] for i in range(I) for j in range(J) for k in range(7))
    mod.addConstrs(temp5[i, j, k, 1] == 1 - X[i, j, k, 2] for i in range(I) for j in range(J) for k in range(7))
    mod.addConstrs(temp5[i, j, k, 2] == 1 - X[i, j, k, 4] for i in range(I) for j in range(J) for k in range(7))
    # this is the final abstract conclusion of constraint
    mod.addConstrs(C[i] == gp.and_(temp5[i, j, k, w] for j in range(J)
                                   for k in range(7) for w in range(3))
                   for i in range(I))

    #optimize the model
    mod.optimize()

    # find where the selected slots are and output the final result excel table
    pos = []
    for i in range(I):
        for j in range(J):
            for k in range(7):
                for w in range(5):
                    if X[i, j, k, w].X == 1:
                        pos.append([i, j, k, w])
    final = pd.DataFrame(data=pos, columns=['course', 'classroom', 'slot', 'weekday'])

    # label the numeric data into clear text
    slots = ['8am', '10am', '12pm', '2pm', '4pm', '6pm', '8pm']
    weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']
    final['course'] = final['course'].map(lambda x: courses.loc[x, 'course'] + ',' + str(courses.loc[x, 'section']))
    final['classroom'] = final['classroom'].map(lambda x: classrooms.loc[x, 'Room'])
    final['slot'] = final['slot'].map(lambda x: slots[x])
    final['weekday'] = final['weekday'].map(lambda x: weekdays[x])

    # write the final table
    final.to_csv(outputFile,index=False)


if __name__ == '__main__':
    import sys
    print(f'Running {sys.argv[0]} using argument list {sys.argv}')
    optimize(sys.argv[1],sys.argv[2])
    print('Schedule Optimized!')