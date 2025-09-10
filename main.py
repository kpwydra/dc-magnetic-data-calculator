from diamag import calc_diamag_contrib

def main():
    formula = input('>')
    result = calc_diamag_contrib(formula=formula)
    print(result)

if __name__ == '__main__': # entry point, first execution step
    main()
