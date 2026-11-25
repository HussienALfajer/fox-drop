import type { Workbook } from 'exceljs';

// An empty Excel workbook, for the exports and the menu import. exceljs takes
// about 0.3 s to load, so it loads with the first workbook a process makes,
// not with the server (and with every server test file).
export async function newWorkbook(): Promise<Workbook> {
  const { default: ExcelJS } = await import('exceljs');
  return new ExcelJS.Workbook();
}
