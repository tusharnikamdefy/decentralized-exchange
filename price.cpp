/*

Calculate the number of B tokens that will be returned for a given
number of A tokens. Uses a transaction fee of .3% and constant mean product.

Args:
  inputAmount: the number of A tokens
  inputReserve: the current number of A tokens that the DEX currently has
  outputReserve: the current number of B tokens that the DEX currently has

Returns:
  The number of B tokens that will be given in exchange for
    inputAmount number of A tokens

*/

#include <iostream>
using namespace std;

double swap_with_tx_fee(double inputAmount, double inputReserve, double outputReserve) {

    double inputAmountFee = inputAmount * 997; //(0.03)
    double numerator = inputAmountFee * outputReserve;
    double denominator = (inputReserve * 1000) + inputAmountFee;
    double result = numerator / denominator;
 
    cout << "WITH .3% tx fee. " << endl;
    cout << "Input reserve: " << inputReserve << "\t Output reserve:" << outputReserve  << endl;
    cout << "Trading "<<inputAmount<<" 'A' tokens for "<<result<<" 'B' tokens."<< endl;
    cout << "----------------------------------------------------" << endl;
    return result;
}
     
double swap_with_no_tx_fee(double inputAmount, double inputReserve, double outputReserve) {
    double numerator = inputAmount * outputReserve;
    double denominator = inputReserve + inputAmount;
    double result = numerator / denominator;
    cout << "WITHOUT tx fee. " << endl;
    cout << "Input reserve: " << inputReserve<< "\t Output reserve:"<<outputReserve<< endl;
    cout << "Trading: " << inputAmount << "'A' tokens for " << result << "'B' tokens."<< endl;
    cout << "----------------------------------------------------" << endl;
    return result;
}

int main() {

    double inputAmount1 = 1, inputReserve1 = 1000, outputReserve1 = 1000;
    swap_with_tx_fee(inputAmount1, inputReserve1, outputReserve1);
    swap_with_no_tx_fee(inputAmount1, inputReserve1, outputReserve1);

    double inputAmount2 = 500, inputReserve2 = 1000, outputReserve2 = 1000;
    swap_with_tx_fee(inputAmount2, inputReserve2, outputReserve2);
    swap_with_no_tx_fee(inputAmount2, inputReserve2, outputReserve2);

   
    double inputAmount3 = 995, inputReserve3 = 1000, outputReserve3 = 1000;
    swap_with_tx_fee(inputAmount3, inputReserve3, outputReserve3);
    swap_with_no_tx_fee(inputAmount3, inputReserve3, outputReserve3);

    return 0;
}
